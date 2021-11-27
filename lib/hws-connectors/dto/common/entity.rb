class Hws::Connectors::Dto::Entity
  attr_accessor :name

  def initialize(name: nil)
    @name = name
  end
end
