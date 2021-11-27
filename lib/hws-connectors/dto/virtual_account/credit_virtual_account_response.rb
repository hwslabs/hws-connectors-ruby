class Hws::Connectors::Dto::CreditVirtualAccountResponse < Hws::Connectors::Response
  attr_accessor :credit_time, :beneficiary, :remitter, :amount, :payment_type, :bank_ref_num

  def initialize(credit_time:, beneficiary:, remitter:, amount:, payment_type:, bank_ref_num:, meta: {})
    @credit_time = credit_time
    @beneficiary = beneficiary
    @remitter = remitter
    @amount = amount
    @payment_type = payment_type
    @bank_ref_num = bank_ref_num
    super(meta: meta)
  end
end
