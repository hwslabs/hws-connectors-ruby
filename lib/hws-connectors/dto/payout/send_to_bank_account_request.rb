class Hws::Connectors::Dto::SendToBankAccountRequest < Hws::Connectors::Request
  include Hws::Connectors::Dto::Payout

  attr_accessor :account_number, :account_ifsc, :amount, :payment_type, :beneficiary_note, :beneficiary_name

  def initialize(reference_number: nil, account_number:, account_ifsc:, amount:, payment_type:, beneficiary_note: nil, beneficiary_name: nil, options: {})
    @reference_number = reference_number
    @account_number = account_number
    @account_ifsc = account_ifsc
    @amount = amount
    @payment_type = payment_type
    @beneficiary_note = beneficiary_note
    @beneficiary_name = beneficiary_name
    super(options)
  end
end
