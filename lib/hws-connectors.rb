module Hws
  class Connectors
    VERSION = '0.1.0'
    ALLOWED_ACTION_CLASSES = [String, Symbol].freeze

    require_relative 'hws-connectors/helper'
    include Hws::Connectors::Helper

    option :logger
    option :root_dir

    class << self
      def configure
        yield self
      end

      def execute_action action, *args
        return nil unless ALLOWED_ACTION_CLASSES.include?(action.class)

        action = action.to_sym
        return nil unless self.methods.include?(action)

        self.send(action, *args)
      end
    end

    def args
      method(__method__).parameters.inject({}) { |res, name| res[name.last] = binding.local_variable_get(name.last); res }
    end
  end
end

require_relative 'hws-connectors/hypto/base'
require_relative 'hws-connectors/hypto/payout'
require_relative 'hws-connectors/yesbank/base'
require_relative 'hws-connectors/yesbank/payout'
