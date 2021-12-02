class Hws::Connectors::Dto::SendToUpiIdRequest < Hws::Connectors::Request
  include Hws::Connectors::Dto::Payout

  attr_accessor :reference_number, :upi_id, :amount, :payment_type, :beneficiary_note, :beneficiary_name, :options
end
