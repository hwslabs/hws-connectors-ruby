class Hws::Connectors::Response < Hws::Connectors
  attr_accessor :message, :meta

  def initialize(message: nil, meta: {})
    @message = message
    @meta = meta.to_h.transform_keys { |key| key.to_sym }
  end
end
