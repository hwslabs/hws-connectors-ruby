class Hws::Connectors::Dto::AccountDetail
  attr_accessor :name, :account_number, :account_ifsc, :upi_id, :note, :created_at, :updated_at

  def initialize(name: nil, account_number: nil, account_ifsc: nil, upi_id: nil, note: nil, created_at: nil, updated_at: nil)
    @name = name
    @account_number = account_number
    @account_ifsc = account_ifsc
    @upi_id = upi_id
    @note = note
    @created_at = created_at
    @updated_at = updated_at
  end
end
