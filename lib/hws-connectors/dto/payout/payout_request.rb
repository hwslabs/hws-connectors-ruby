class Hws::Connectors::Dto::PayoutRequest < Hws::Connectors::Request
  attr_accessor :beneficiary, :amount, :payment_type

  def initialize(beneficiary:, amount:, payment_type:, reference_number: nil, meta: {})
    @beneficiary = beneficiary
    @amount = amount
    @payment_type = payment_type
    super(reference_number: reference_number, meta: meta)
  end
end
