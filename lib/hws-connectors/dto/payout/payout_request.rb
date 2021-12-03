class Hws::Connectors::Dto::PayoutRequest < Hws::Connectors::Request
  attr_accessor :beneficiary, :amount, :payment_type

  def initialize(reference_number: nil, beneficiary:, amount:, payment_type:, meta: {})
    @reference_number = reference_number
    @beneficiary = beneficiary
    @amount = amount
    @payment_type = payment_type
    super(meta)
  end
end
