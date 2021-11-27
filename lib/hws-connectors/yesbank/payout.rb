class Hws::Connectors::Yesbank::Payout < Hws::Connectors::Yesbank::Base
  URL_PATHS = { 'status' => 'getStatus', 'initiate' => 'startTransfer', 'balance' => 'getBalance' }

  option :payout_config, -> { configs['payout'] }
  option :certificate, -> do
    cert_file = File.join(Hws::Connectors.options[:root_dir], 'config', "#{payout_config['cert_file_name']}.p12")
    OpenSSL::PKCS12.new(cert_file, payout_config['cert_password'])
  end

  class << self
    def transfer beneficiary, payment_type, amount, reference_number
      return reference_number if BANK_CONFIG['disabled']

      payload = {
        'startTransfer' => {
          'version' => '1', 'uniqueRequestNo' => reference_number, 'appID' => BANK_CONFIG['app_id'], 'purposeCode' => 'REFUND',
          'customerID' => BANK_CONFIG['customer_id'], 'debitAccountNo' => BANK_CONFIG['debit_account_number'], 'transferAmount' => amount.to_f,
          'transferCurrencyCode' => 'INR', 'remitterToBeneficiaryInfo' => beneficiary.note, 'transferType' => payment_type,
          'beneficiary' => {
            'beneficiaryDetail' => {
              'beneficiaryName' => { 'fullName' => beneficiary.name },
              'beneficiaryAddress' => { 'address1' => BANK_CONFIG['beneficiary_address'], 'country' => 'IN' },
              'beneficiaryContact' => { 'mobileNo' => BANK_CONFIG['beneficiary_mobile_number'], 'emailID' => BANK_CONFIG['beneficiary_email'] },
              'beneficiaryAccountNo' => beneficiary.account_number, 'beneficiaryIFSC' => beneficiary.ifsc
            }
          }
        }
      }.to_json
      Hws::Connectors.logger.debug "Hws::Connectors::yesbank::Payout.transfer : ReferenceNumber - #{reference_number} : Request Body - #{payload}"

      begin
        resp = RestClient.post("#{BANK_CONFIG['endpoint']}/#{URL_PATHS['initiate']}", payload, HEADERS, ssl_client_cert: P12_CONFIG.certificate,
                               ssl_client_key: P12_CONFIG.key, verify_ssl: OpenSSL::SSL::VERIFY_NONE)
        resp_body = resp.body
        raise "Unable to initiate transfer : #{resp.code}" if (resp.code / 100).to_i != 2

        Hws::Connectors.logger.debug "Hws::Connectors::yesbank::Payout.transfer : ReferenceNumber - #{reference_number} : Response Body - #{resp_body}"
        return JSON.parse(resp_body)['startTransferResponse']
      rescue => e
        Hws::Connectors.logger.error "Hws::Connectors::yesbank::Payout.transfer : ReferenceNumber - #{reference_number} : Error Message - #{e.message} - Error Body - #{e.try(:response).try(:body)}"
        return { 'reference_number' => reference_number }
      end
    end
  end

  def headers
    { 'Content-Type' => 'application/json', 'Authorization' => "Basic #{Payout.configs['auth_token']}",
      'X-IBM-Client-Id' => Payout.configs['client_id'], 'X-IBM-Client-Secret' => Payout.configs['client_secret'] }
  end
end
