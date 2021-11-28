class Hws::Connectors::Hypto < Hws::Connectors
  BASE_URL = 'https://partners.hypto.in'
  NAME = 'hypto'
  END_POINTS = ::YAML.load_file(File.join(__dir__, '../', 'endpoints', "#{NAME}.yml"))

  option :api_token

  def initialize(options = {})
    @api_token = options['api_token']
    @webhook_auth = options['webhook_auth']
  end

  protected

  def initiate_request(_method, payload = {})
    begin
      _class = self.class.name
      Hws::Connectors.logger.debug "===== #{_class}.#{_method} - args: #{payload} ====="
      end_point = END_POINTS[_class][_method.to_s]
      end_point['path'] = end_point['path'] % payload.symbolize_keys if end_point['path'].include? '%'

      resp = RestClient::Request.execute(url: "#{BASE_URL}#{end_point['path']}", method: end_point['method'], payload: payload.to_json, headers: headers).body
      Hws::Connectors.logger.debug "===== #{_class}.#{_method} - Response: #{resp} =====" if Hws::Connectors.logging?(end_point['method'])
      return JSON.parse(resp)
    rescue => e
      puts e.message
      puts e.class

      error = e.try(:response).try(:body)
      Hws::Connectors.logger.error "===== #{_class}.#{_method} - Error: #{error} ====="
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

  def valid_webhook?(authorization)
    @webhook_auth.nil? || authorization == @webhook_auth
  end

  private

  def headers
    { 'Authorization' => @api_token, 'Content-Type' => 'application/json' }
  end
end
