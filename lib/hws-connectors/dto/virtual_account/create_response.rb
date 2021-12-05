class Hws::Connectors::Dto::CreateVirtualAccountResponse < Hws::Connectors::Response
  attr_accessor :reference_number

  def initialize(reference_number:, beneficiary:, remitters: [], status: nil, balance: nil, message: nil, meta: {})
    @reference_number = reference_number
    @beneficiary = beneficiary
    @remitters = remitters
    @status = status
    @balance = balance
    super(message: message, meta: meta)
  end
end
