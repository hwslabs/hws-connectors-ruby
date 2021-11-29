class Hws::Connectors::Hypto::Payout < Hws::Connectors::Hypto
  def send_to_bank_account(reference_number: nil, payment_type:, account_ifsc:, account_number:, amount:, beneficiary_note:, beneficiary_name: nil, options: {})
    payload = { reference_number: reference_number, payment_type: payment_type, amount: amount, number: account_number, ifsc: account_ifsc,
                note: beneficiary_note, udf1: options['udf1'], udf2: options['udf2'], udf3: options['udf3'], beneficiary_name: beneficiary_name }
    initiate_request(__method__, payload)
  end

  def send_to_upi_id(reference_number: nil, upi_id:, amount:, beneficiary_note:, beneficiary_name: nil, options: {})
    payload = { reference_number: reference_number, payment_type: 'UPI', amount: amount, upi_id: upi_id,
                note: beneficiary_note, udf1: options['udf1'], udf2: options['udf2'], udf3: options['udf3'], beneficiary_name: beneficiary_name }
    initiate_request(__method__, payload)
  end

  def status(reference_number:)
    payload = { reference_number: reference_number }
    initiate_request(__method__, payload)
  end
end
