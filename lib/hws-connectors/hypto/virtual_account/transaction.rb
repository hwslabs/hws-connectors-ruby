module Hws::Connectors::Hypto::VirtualAccount::Transaction
  TXN_META_RESPONSES = %w(id txn_time created_at txn_type charges_gst settled_amount closing_balance connected_banking transfer_udf1 transfer_udf2 transfer_udf3 transfer_initiated_account_ifsc hypto_va_id va_closing_balance va_wallet_amount)

  # @param [Types::PayoutRequest] request
  # @return [Types::PayoutResponse]
  def send_to_bank_account(request:)
    beneficiary = request.beneficiary
    payload = { reference_number: request.reference_number, number: beneficiary.account_number, ifsc: beneficiary.account_ifsc, amount: request.amount,
                payment_type: request.payment_type, note: beneficiary.note, beneficiary_name: beneficiary.name, udf1: request.meta[:udf1],
                udf2: request.meta[:udf2], udf3: request.meta[:udf3], id: request.meta[:va_id] }
    resp = initiate_request(__method__, payload)
    to_txn_response(resp['data'], resp['message'])
  end

  # @param [Types::PayoutRequest] request
  # @return [Types::PayoutResponse]
  def send_to_upi_id(request:)
    beneficiary = request.beneficiary
    payload = { reference_number: request.reference_number, upi_id: beneficiary.upi_id, amount: request.amount, payment_type: 'UPI',
                note: beneficiary.note, beneficiary_name: beneficiary.name, udf1: request.meta[:udf1],
                udf2: request.meta[:udf2], udf3: request.meta[:udf3], id: request.meta[:va_id] }
    resp = initiate_request(__method__, payload)
    to_txn_response(resp['data'], resp['message'])
  end

  # @param [Types::String] reference_number
  # @return [Types::PayoutResponse]
  def status(reference_number:, va_id: nil)
    payload = { reference_number: reference_number, id: va_id }
    resp = initiate_request(__method__, payload)
    to_txn_response(resp['data'], resp['message'])
  end

  def statement(payload = {})
    # TODO: Create models for request & response
    initiate_request(__method__, payload)
  end

  private

  def to_txn_response(resp_data, message)
    beneficiary = Hws::Connectors::Dto::Beneficiary
                    .new(name: resp_data['transfer_beneficiary_name'], account_number: resp_data['transfer_account_number'],
                         account_ifsc: resp_data['transfer_account_ifsc'], note: resp_data['transfer_note'])
    Hws::Connectors::Dto::PayoutResponse
      .new(reference_number: resp_data['reference_number'], beneficiary: beneficiary, account_holder: resp_data['transfer_account_holder'],
           amount: resp_data['settled_amount'], payment_type: resp_data['payment_type'], status: resp_data['status'], message: message,
           txn_time: Time.strptime(resp_data['txn_time'], '%Y-%m-%d %H:%M:%S'), meta: resp_data.slice(*TXN_META_RESPONSES))
  end
end
