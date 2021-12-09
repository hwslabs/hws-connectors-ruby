class Hws::Connectors::Dto::VirtualAccountResponse < Hws::Connectors::Response
  attr_accessor :id, :reference_number, :beneficiary, :remitters, :status, :balance

  def initialize(id:, reference_number:, beneficiary:, remitters: [], status: nil, balance: nil, message: nil, meta: {})
    @id = id
    @reference_number = reference_number
    @beneficiary = beneficiary
    @remitters = remitters
    @status = status
    @balance = balance
    super(message: message, meta: meta)
  end
end
