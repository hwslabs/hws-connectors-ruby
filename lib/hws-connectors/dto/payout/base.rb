module Hws::Connectors::Dto::Payout
end

class Hws::Connectors::Dto::Beneficiary
  attr_accessor :name, :account_number, :account_ifsc, :upi_id, :note

  def initialize(name: nil, account_number: nil, account_ifsc: nil, upi_id: nil, note: nil)
    @name = name
    @account_number = account_number
    @account_ifsc = account_ifsc
    @upi_id = upi_id
    @note = note
  end
end

require 'hws-connectors/dto/payout/send_to_bank_account_request'
require 'hws-connectors/dto/payout/send_to_bank_account_response'
require 'hws-connectors/dto/payout/send_to_upi_id_request'
require 'hws-connectors/dto/payout/send_to_upi_id_response'
