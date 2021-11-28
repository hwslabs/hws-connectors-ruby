module Hws::Connectors::Helper
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def option(param, block = nil)
      [self, self.class].each do |_class|
        _class.class_eval do
          attr_accessor(param)
          next if block.nil?

          define_method(param) do
            instance_variable_set("@#{param}", block.call) if instance_variable_get("@#{param}").nil?
            instance_variable_get("@#{param}")
          end
        end
      end
    end
  end
end
