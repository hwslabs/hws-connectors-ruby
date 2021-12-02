class Hws::Connectors::Request < Hws::Connectors
  attr_accessor :reference_number, :meta

  def initialize(reference_number: nil, meta: {})
    @reference_number = reference_number
    @meta = meta
  end
end
