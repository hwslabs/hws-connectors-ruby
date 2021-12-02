class Hws::Connectors::Dto::CreateVirtualAccountRequest < Hws::Connectors::Dto
  attr_reader :reference_number, :account_number, :account_ifsc, :amount, :payment_type, :beneficiary_note, :beneficiary_name, :options
end

# class Hws::Connectors::Models::CreateVirtualAccount < Hws::Connectors::Models
#   attr_reader :reference_number, :account_number, :account_ifsc, :amount, :payment_type, :beneficiary_note, :beneficiary_name, :options
# end
