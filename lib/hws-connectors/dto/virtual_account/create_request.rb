class Hws::Connectors::Dto::CreateVirtualAccountRequest < Hws::Connectors::Request
  attr_accessor :remitters

  def initialize(reference_number:, remitters: [], meta: {})
    @remitters = remitters
    super(reference_number: reference_number, meta: meta)
  end
end
