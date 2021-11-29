module Hws
  class Connectors
    VERSION = '0.1.0'

    require 'hws-connectors/exception'
    include Hws::Connectors::Exception
    require 'hws-connectors/helper'
    include Hws::Connectors::Helper

    option :logger
    option :root_dir
    option :options

    class << self
      def configure
        yield self
        self
      end

      def logging?(_method)
        !options['skip_logging'].to_a.include?(_method.to_s)
      end
    end
  end
end

require 'hws-connectors/hypto/base'
