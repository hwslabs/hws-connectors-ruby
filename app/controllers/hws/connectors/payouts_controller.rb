class Hws::Connectors::PayoutsController < Hws::Connectors::WebhooksController
  HYPTO_META_RESPONSES = %w(id txn_time created_at txn_type charges_gst settled_amount connected_banking udf1 udf2 udf3 initiated_account_ifsc
va_closing_balance hypto_va_id va_wallet_amount va_settler_id)

  def callback
    Hws::Connectors.logger.debug "===== Hws::Connectors::PayoutsController.callback - Payload: #{params.inspect} ====="
    beneficiary = Hws::Connectors::Dto::AccountDetail
                    .new(name: params['beneficiary_name'], account_number: params['account_number'],
                         account_ifsc: params['account_ifsc'], note: params['note'])
    response = Hws::Connectors::Dto::PayoutResponse
                 .new(reference_number: params['reference_number'], beneficiary: beneficiary, account_holder: params['account_holder'],
                      amount: params['amount'].to_f, payment_type: params['payment_type'], status: params['status'],
                      txn_time: Time.strptime(params['txn_time'], '%Y-%m-%d %H:%M:%S'), meta: params.as_json.slice(*HYPTO_META_RESPONSES))

    render_response(response)
  end
end
