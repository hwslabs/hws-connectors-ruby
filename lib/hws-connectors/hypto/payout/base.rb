class Hws::Connectors::Hypto::Payout < Hws::Connectors::Hypto
  META_RESPONSES = %w(id txn_time created_at txn_type charges_gst settled_amount closing_balance connected_banking transfer_udf1 transfer_udf2 transfer_udf3 transfer_initiated_account_ifsc)

  # @!group Actions

  # @param [Dto::PayoutRequest] request
  # @return [Dto::PayoutResponse]
  def send_to_bank_account(request:)
    beneficiary = request.beneficiary
    payload = { reference_number: request.reference_number, number: beneficiary.account_number, ifsc: beneficiary.account_ifsc, amount: request.amount,
                payment_type: request.payment_type, note: beneficiary.note, beneficiary_name: beneficiary.name, udf1: request.meta[:udf1],
                udf2: request.meta[:udf2], udf3: request.meta[:udf3] }
    resp = initiate_request(__method__, payload)
    to_response(resp['data'], resp['message'])
  end

  # @param [Dto::PayoutRequest] request
  # @return [Dto::PayoutResponse]
  def send_to_upi_id(request:)
    beneficiary = request.beneficiary
    payload = { reference_number: request.reference_number, upi_id: beneficiary.upi_id, amount: request.amount, payment_type: 'UPI',
                note: beneficiary.note, beneficiary_name: beneficiary.name, udf1: request.meta[:udf1],
                udf2: request.meta[:udf2], udf3: request.meta[:udf3] }
    resp = initiate_request(__method__, payload)
    to_response(resp['data'], resp['message'])
  end

  # @param [String] reference_number
  # @return [Dto::PayoutResponse]
  def status(reference_number:)
    payload = { reference_number: reference_number }
    resp = initiate_request(__method__, payload)
    to_response(resp['data'], resp['message'])
  end

  private

  def to_response(resp_data, message)
    beneficiary = Hws::Connectors::Dto::AccountDetail
                    .new(name: resp_data['transfer_beneficiary_name'], account_number: resp_data['transfer_account_number'],
                         account_ifsc: resp_data['transfer_account_ifsc'], note: resp_data['transfer_note'])
    Hws::Connectors::Dto::PayoutResponse
      .new(reference_number: resp_data['reference_number'], beneficiary: beneficiary, account_holder: resp_data['transfer_account_holder'],
           amount: resp_data['settled_amount'], payment_type: resp_data['payment_type'], status: resp_data['status'], message: message,
           bank_ref_num: resp_data['bank_ref_num'], txn_time: Time.strptime(resp_data['txn_time'], '%Y-%m-%d %H:%M:%S'),
           meta: resp_data.slice(*META_RESPONSES))
  end
end
