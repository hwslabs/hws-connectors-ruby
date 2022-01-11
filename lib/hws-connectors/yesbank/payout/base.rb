class Hws::Connectors::Yesbank::Payout < Hws::Connectors::Yesbank
  META_RESPONSES = %w(uniqueResponseNo statusCode reqTransferType)

  # @!group Actions

  # @param [Dto::PayoutRequest] request
  # @return [Dto::PayoutResponse]
  def send_to_bank_account(request:)
    beneficiary = request.beneficiary
    payload = {
      'startTransfer' => {
        'version' => '1', 'uniqueRequestNo' => request.reference_number, 'appID' => @customer_id, 'purposeCode' => 'REFUND',
        'customerID' => @customer_id, 'debitAccountNo' => @debit_account_number, 'transferAmount' => request.amount.to_f,
        'transferCurrencyCode' => 'INR', 'remitterToBeneficiaryInfo' => beneficiary.note, 'transferType' => request.payment_type,
        'beneficiary' => {
          'beneficiaryDetail' => {
            'beneficiaryName' => { 'fullName' => beneficiary.name },
            'beneficiaryAddress' => { 'address1' => request.beneficiary.address || @proxy_beneficiary_address, 'country' => 'IN' },
            'beneficiaryContact' => { 'mobileNo' => request.beneficiary.mobile || @proxy_beneficiary_mobile, 'emailID' => request.beneficiary.email || @proxy_beneficiary_email },
            'beneficiaryAccountNo' => beneficiary.account_number, 'beneficiaryIFSC' => beneficiary.account_ifsc
          }
        }
      }
    }

    resp = initiate_request(__method__, payload)
    resp_data = resp['startTransferResponse']
    to_response(resp['startTransferResponse'])
  end

  # @param [String] reference_number
  # @return [Dto::PayoutResponse]
  def status(reference_number:)
    payload = { 'getStatus' => { 'version' => '1', 'appID' => @customer_id, 'customerID' => @customer_id, 'requestReferenceNo' => reference_number } }.to_json
    resp = initiate_request(__method__, payload)
    # TODO: Handle payout error - @logeshdinahypto
    to_response(resp['getStatusResponse'])
  end

  private

  def to_response(resp_data)
    Hws::Connectors::Dto::PayoutResponse.new(reference_number: resp_data['requestReferenceNo'], meta: resp_data.slice(*META_RESPONSES))
  end
end
