require 'yaml'
require 'rest-client'

class Hws::Connectors::Yesbank < Hws::Connectors
  NAME = 'yesbank'.freeze
  END_POINTS = ::YAML.load_file(File.join(__dir__, 'endpoints.yml')).freeze
  P12_CONFIG =

  def initialize(options = {})
    @auth_token = options['auth_token']
    @client_id = options['client_id']
    @client_secret = options['client_secret']
    @customer_id = options['customer_id']
    @debit_account_number = options['debit_account_number']
    @certificate = OpenSSL::PKCS12.new(File.read(options['cert_file_path']), options['cert_file_password'])
    @proxy_beneficiary_email = options['proxy_beneficiary_email']
    @proxy_beneficiary_mobile = options['proxy_beneficiary_mobile']
    @proxy_beneficiary_address = options['proxy_beneficiary_address']
    super()
  end

  protected

  def initiate_request(method, payload = {})
    begin
      _class = self.class.name
      Hws::Connectors.logger.debug "===== #{_class}.#{method} - args: #{payload} ====="

      end_point = END_POINTS[_class][method.to_s].clone
      resp = RestClient::Request.execute(url: "#{@base_url}#{end_point['path']}", method: end_point['method'], payload: payload.to_json, headers: headers,
                                         ssl_client_cert: @certificate.certificate, ssl_client_key: @certificate.key, verify_ssl: OpenSSL::SSL::VERIFY_NONE).body
      Hws::Connectors.logger.debug "===== #{_class}.#{method} - Response: #{resp} =====" if Hws::Connectors.logging?(end_point['method'])
      return JSON.parse(resp)
    rescue => e
      error = e.try(:response).try(:body)
      Hws::Connectors.logger.error "===== #{_class}.#{method} - Error: #{error} ====="
      error = JSON.parse(error) if error.present?

      case e.class.name
      when 'RestClient::Unauthorized'
        raise Hws::Connectors::Exception::UnAuthorized.new(error)
      when 'RestClient::TooManyRequests'
        raise Hws::Connectors::Exception::RatelimitExceeded.new(error)
      when 'RestClient::BadRequest', 'RestClient::NotFound'
        case error['reason']
        when 'Action Denied. Your account balance is negative'
          raise Hws::Connectors::Exception::LowBalance.new(error)
        else
          raise Hws::Connectors::Exception::Error.new(error)
        end
      else
        raise Hws::Connectors::Exception::Error.new(e.message)
      end
    end
  end

  private

  def headers
    { 'Content-Type' => 'application/json', 'Authorization' => "Basic #{@auth_token}", 'X-IBM-Client-Id' => @client_id,
      'X-IBM-Client-Secret' => @client_secret }
  end
end

require_relative 'payout/base'
