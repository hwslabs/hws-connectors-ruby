class Hws::Connectors::Hypto::VirtualAccount < Hws::Connectors::Hypto
  META_RESPONSES = %w(id account_number udf1 udf2 udf3 settle_to parent_id parent_type level hierarchy created_at updated_at link_upi upi_details)

  # @!group Actions

  # require_relative 'transaction'
  # include Transaction

  # @param [Types::VirtualAccountRequest] request
  # @return [Types::VirtualAccountResponse]
  def create(request:)
    payload = { reference_number: request.reference_number, udf1: request.meta[:udf1], udf2: request.meta[:udf2], udf3: request.meta[:udf3],
                settle_to: request.meta[:settle_to], parent_type: request.meta[:parent_type], parent_id: request.meta[:parent_id],
                whitelisted_remitters: request.remitters.map { |remitter| { number: remitter.beneficiary.account_number, ifsc: remitter.beneficiary.account_ifsc } },
                link_upi: request.meta[:link_upi], upi_name: request.meta[:upi_name] }
    resp = initiate_request(__method__, payload)
    to_response(resp['data']['virtual_account'])
  end

  # @param [Types::String] reference_number
  # @return [Types::VirtualAccountResponse]
  def fetch(reference_number:)
    payload = { id: reference_number }
    resp = initiate_request(__method__, payload)
    to_response(resp['data'])
  end

  # @param [Types::VirtualAccountRequest] request
  # @return [Types::VirtualAccountResponse]
  def update(request:)
    payload = { id: request.meta[:id], reference_number: request.reference_number, udf1: request.meta[:udf1], udf2: request.meta[:udf2], udf3: request.meta[:udf3],
                whitelisted_remitters: request.remitters.map { |remitter| { number: remitter.beneficiary.account_number, ifsc: remitter.beneficiary.account_ifsc } } }
    resp = initiate_request(__method__, payload)
    to_response(resp['data']['virtual_account'])
  end

  # @param [Types::String] reference_number
  # @return [Types::VirtualAccountResponse]
  def activate(reference_number:)
    payload = { id: reference_number }
    resp = initiate_request(__method__, payload)
    to_response(resp['data'])
  end

  # @param [Types::String] reference_number
  # @return [Types::VirtualAccountResponse]
  def deactivate(reference_number:)
    payload = { id: reference_number }
    resp = initiate_request(__method__, payload)
    to_response(resp['data'])
  end

  def list(payload = {})
    # TODO: Create models for request & response
    initiate_request(__method__, payload)
  end

  def search(payload = {})
    # TODO: Create models for request & response
    initiate_request(__method__, payload)
  end

  private

  def to_response resp_data
    resp_account_data = resp_data['details'][0]
    beneficiary = Hws::Connectors::Dto::Beneficiary.new(account_number: resp_account_data['account_number'], account_ifsc: resp_account_data['account_ifsc'])

    remitters = []
    resp_data['whitelisted_remitters'].each do |wl_rmtr|
      wl_bene_data = Hws::Connectors::Dto::Beneficiary.new(account_number: wl_rmtr['number'], account_ifsc: wl_rmtr['ifsc'])
      remitters << Hws::Connectors::Dto::Remitter.new(beneficiary: wl_bene_data, created_at: wl_rmtr['created_at'], updated_at: wl_rmtr['updated_at'])
    end

    Hws::Connectors::Dto::VirtualAccountResponse
      .new(reference_number: resp_data['reference_number'], beneficiary: beneficiary, remitters: remitters, status: resp_data['status'],
           balance: resp_data['account_balance'], message: resp['message'], meta: resp_data.slice(*META_RESPONSES))
  end
end
