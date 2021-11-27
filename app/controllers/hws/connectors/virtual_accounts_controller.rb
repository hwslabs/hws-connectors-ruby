class Hws::Connectors::VirtualAccountsController < Hws::Connectors::WebhooksController
  HYPTO_META_RESPONSES = %w(id va_closing_balance va_settler_id charges_gst settled_amount txn_time created_at hypto_va_id va_wallet_amount va_lien_amount)

  def notify
    Hws::Connectors.logger.debug "===== Hws::Connectors::VirtualAccountsController.notify - Payload: #{params.inspect} ====="
    beneficiary = Hws::Connectors::Dto::AccountDetail.new(account_number: params['bene_account_no'], account_ifsc: params['bene_account_ifsc'])
    remitter = Hws::Connectors::Dto::AccountDetail.new(account_number: params['rmtr_account_no'], account_ifsc: params['rmtr_account_ifsc'],
                                                       note: params['rmtr_to_bene_note'], name: params['rmtr_full_name'])

    response = Hws::Connectors::Dto::CreditVirtualAccountResponse
                 .new(credit_time: Time.strptime(params['credited_at'], '%Y-%m-%d %H:%M:%S'), beneficiary: beneficiary, remitter: remitter, amount: params['amount'].to_f,
                      payment_type: params['payment_type'], bank_ref_num: params['bank_ref_num'], meta: params.as_json.slice(*HYPTO_META_RESPONSES))
    render_response(response)
  end
end
