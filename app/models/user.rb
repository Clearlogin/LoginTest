class User < ActiveRecord::Base
  has_secure_password
  has_many :rules

  attr_accessor :allowed_rules

  # White-listed approach for the Permission: 
  # - If user has no rule: Return empty array, deny everything from all IP addresses.
  # - If user has some allowed rules and some denied rules: We care for only allowed rules for the request ip, deny everything else.
  # - If user has only denied rules: Deny everything.
  def set_allowed_rules(ip_address)
    self.allowed_rules = self.rules.map { |x| x if x.permission == Rule::ALLOW && IPAddr.new(x.cidr).include?(IPAddr.new(ip_address)) }.compact
  end  
end
