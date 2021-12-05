class Hws::Connectors::Dto::Remitter
  attr_accessor :beneficiary, :created_at, :updated_at

  def initialize(beneficiary:, created_at: nil, updated_at: nil)
    @beneficiary = beneficiary
    @created_at = created_at
    @updated_at = updated_at
  end
end
