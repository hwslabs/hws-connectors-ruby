module Hws::Connectors::Hypto::VirtualAccount::Transaction
  def send_to_bank_account(payload = {})
    initiate_request(__method__, payload)
  end

  def send_to_upi_id(payload = {})
    payload['payment_type'] ||= 'UPI'
    initiate_request(__method__, payload)
  end

  def status(payload = {})
    initiate_request(__method__, payload)
  end

  def statement(payload = {})
    initiate_request(__method__, payload)
  end
end
