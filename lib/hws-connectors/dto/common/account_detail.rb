class Hws::Connectors::Dto::AccountDetail
  attr_accessor :name, :account_number, :account_ifsc, :upi_id, :note, :address, :email, :mobile, :created_at, :updated_at

  def initialize(name: nil, account_number: nil, account_ifsc: nil, upi_id: nil, note: nil, address: nil, email: nil,
                 mobile: nil, created_at: nil, updated_at: nil)
    @name = name
    @account_number = account_number
    @account_ifsc = account_ifsc
    @upi_id = upi_id
    @note = note
    @address = address
    @email = email
    @mobile = mobile
    @created_at = created_at
    @updated_at = updated_at
  end
end
