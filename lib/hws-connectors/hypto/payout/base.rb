class Hws::Connectors::Hypto::Payout < Hws::Connectors::Hypto
  META_RESPONSES = %w(id txn_time created_at txn_type charges_gst settled_amount closing_balance connected_banking transfer_udf1 transfer_udf2 transfer_udf3 transfer_initiated_account_ifsc)

  def send_to_bank_account(request)
    payload = { reference_number: request.reference_number, number: request.account_number, ifsc: request.account_ifsc, amount: request.amount,
                payment_type: request.payment_type, note: request.beneficiary_note, beneficiary_name: request.beneficiary_name, udf1: request.options['udf1'],
                udf2: request.options['udf2'], udf3: request.options['udf3'] }
    resp = initiate_request(__method__, payload)
    resp_data = resp['data']
    beneficiary = Hws::Connectors::Dto::Beneficiary
                    .new(name: resp_data['transfer_beneficiary_name'], account_number: resp_data['transfer_account_number'],
                         account_ifsc: resp_data['transfer_account_ifsc'], note: resp_data['transfer_note'])
    Hws::Connectors::Dto::SendToBankAccountResponse
      .new(reference_number: resp_data['reference_number'], beneficiary: beneficiary, account_holder: resp_data['transfer_account_ifsc'],
           amount: resp_data['amount'], payment_type: resp_data['payment_type'], status: resp_data['status'], message: resp['message'],
           txn_time: Time.strptime(resp_data['txn_time'], '%Y-%m-%d %H:%M:%S'), meta: resp_data.slice(META_RESPONSES))
  end

  def send_to_upi_id(reference_number: nil, upi_id:, amount:, beneficiary_note:, beneficiary_name: nil, options: {})
    payload = { reference_number: reference_number, upi_id: upi_id, amount: amount, payment_type: 'UPI',
                note: beneficiary_note, beneficiary_name: beneficiary_name, udf1: options['udf1'], udf2: options['udf2'], udf3: options['udf3'] }
    initiate_request(__method__, payload)
  end

  def status(reference_number:)
    payload = { reference_number: reference_number }
    initiate_request(__method__, payload)
  end
end
