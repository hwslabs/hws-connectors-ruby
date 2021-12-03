class Hws::Connectors::Dto::PayoutResponse < Hws::Connectors::Response
  attr_accessor :reference_number, :account_holder, :amount, :payment_type, :beneficiary
  attr_accessor :txn_time, :status, :bank_ref_num

  def initialize(reference_number:, beneficiary:, account_holder: nil, amount:, payment_type:, txn_time:, status:, bank_ref_num: nil,
                 message: nil, meta: {})
    @reference_number = reference_number
    @beneficiary = beneficiary
    @account_holder = account_holder
    @amount = amount
    @payment_type = payment_type
    @txn_time = txn_time
    @status = status
    @bank_ref_num = bank_ref_num
    super(message: message, meta: meta)
  end
end
