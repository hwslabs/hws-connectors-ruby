require 'yaml'
require 'rest-client'

class Hws::Connectors::Hypto < Hws::Connectors
  NAME = 'hypto'.freeze
  END_POINTS = ::YAML.load_file(File.join(__dir__, 'endpoints.yml')).freeze

  def initialize(options = {})
    @api_token = options['api_token']
    @base_url = "https://partners.hypto#{'.co' if options['env'].try(:to_sym) != :production}.in"
  end

  protected

  def initiate_request(method, payload = {})
    begin
      _class = self.class.name
      Hws::Connectors.logger.debug "===== #{_class}.#{method} - args: #{payload} ====="

      end_point = END_POINTS[_class][method.to_s].clone
      end_point['path'] = end_point['path'] % payload if end_point['path'].include?('%')

      resp = RestClient::Request.execute(url: "#{@base_url}#{end_point['path']}", method: end_point['method'], payload: payload.to_json, headers: headers).body
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
    { 'Authorization' => @api_token, 'Content-Type' => 'application/json' }
  end
end

require_relative 'virtual_account/base'
require_relative 'payout/base'
