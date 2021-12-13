require 'rails/railtie'

class Hws::Connectors::Railtie < ::Rails::Railtie
  initializer 'Configure Rails Logger' do
    Hws::Connectors.configure do |config|
      config.logger = ::Rails.logger
      config.options = { skip_logging: %w(get) }
    end
  end
end
