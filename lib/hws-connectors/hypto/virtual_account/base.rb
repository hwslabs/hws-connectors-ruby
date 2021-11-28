class Hws::Connectors::Hypto::VirtualAccount < Hws::Connectors::Hypto
  require_relative 'transaction'
  include Transaction

  def create(payload = {})
    initiate_request(__method__, payload)
  end

  def fetch(payload = {})
    initiate_request(__method__, payload)
  end

  def update(payload = {})
    initiate_request(__method__, payload)
  end

  def activate(payload = {})
    initiate_request(__method__, payload)
  end

  def deactivate(payload = {})
    initiate_request(__method__, payload)
  end

  def list(payload = {})
    initiate_request(__method__, payload)
  end

  def search(payload = {})
    initiate_request(__method__, payload)
  end
end
