class Hws::Connectors::Base
  ALLOWED_ACTION_CLASSES = [String, Symbol].freeze

  def self.execute_action action, *args
    return nil unless ALLOWED_ACTION_CLASSES.include?(action.class)

    action = action.to_sym
    return nil unless self.methods.include?(action)

    self.send(action, *args)
  end
end
