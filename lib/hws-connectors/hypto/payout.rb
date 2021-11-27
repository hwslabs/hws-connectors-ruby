class Hws::Connectors::Hypto::Payout < Hws::Connectors::Hypto::Base

  def self.send_to_bank_account creds, ref_num, pymt_type, ifsc, number, amount, note, bene_name, options = {}
    args = method(__method__).parameters.inject({}) { |res, name| res[name.last] = binding.local_variable_get(name.last); res }
    Rails.logger.debug "===== Hws::Connectors::Base::Payout.send_to_bank_account - args: #{args} =="
  end

  def self.send_to_upi_id creds, ref_num, upi_id, amount, note, bene_name, options = {}
    args = method(__method__).parameters.inject({}) { |res, name| res[name.last] = binding.local_variable_get(name.last); res }
    Rails.logger.debug "===== Hws::Connectors::Base::Payout.send_to_upi_id - args: #{args} =="
  end

  def self.status creds, ref_num
    args = method(__method__).parameters.inject({}) { |res, name| res[name.last] = binding.local_variable_get(name.last); res }
    Rails.logger.debug "===== Hws::Connectors::Base::Payout.status - args: #{args} =="    
  end

end
