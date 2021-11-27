module Hws::Connectors::Helper
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def option(param, block = nil)
      self.class.class_eval do
        attr_accessor(param)
        return if block.nil?

        define_method(param) do
          instance_variable_set("@#{param}", block.call) if instance_variable_get("@#{param}").nil?
          instance_variable_get("@#{param}")
        end
      end
    end
  end
end
