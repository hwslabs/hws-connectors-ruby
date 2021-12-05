class Hws::Connectors::Dto::VirtualAccountRequest < Hws::Connectors::Request
  attr_accessor :remitters

  def initialize(reference_number:, remitters: [], meta: {})
    @remitters = remitters
    super(reference_number: reference_number, meta: meta)
  end
end
