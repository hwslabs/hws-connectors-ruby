class Hws::Connectors::Response < Hws::Connectors
  attr_accessor :message, :meta

  def initialize(message:, meta:)
    @message = message
    @meta = meta
  end
end
