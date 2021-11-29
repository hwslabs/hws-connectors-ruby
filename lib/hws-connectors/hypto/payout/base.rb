class Hws::Connectors::Hypto::Payout < Hws::Connectors::Hypto
  def send_to_bank_account(reference_number: nil, account_number:, account_ifsc:, amount:, payment_type:, beneficiary_note:, beneficiary_name: nil, options: {})
    payload = { reference_number: reference_number, number: account_number, ifsc: account_ifsc, amount: amount, payment_type: payment_type,
                note: beneficiary_note, beneficiary_name: beneficiary_name, udf1: options['udf1'], udf2: options['udf2'], udf3: options['udf3'] }
    initiate_request(__method__, payload)
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
