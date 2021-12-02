class Hws::Connectors::Dto::SendToUpiIdResponse < Hws::Connectors::Response
  include Hws::Connectors::Dto::Payout

  attr_accessor :reference_number, :upi_id, :amount, :payment_type, :beneficiary_note, :beneficiary_name, :options
end
