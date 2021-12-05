class Hws::Connectors::Dto::VirtualAccountRequest < Hws::Connectors::Request
  attr_accessor :remitters

  def initialize(remitters: [], reference_number:, meta: {})
    @remitters = remitters
    super(reference_number: reference_number, meta: meta)
  end
end
