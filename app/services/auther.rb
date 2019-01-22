class Auther
  UNAUTHORIZED_MESSAGE = 'Wrong credential. Access denied.'

  # Authenticate user
  # parameters:
  # - username:   String - username of User
  # - password:   String - password of User
  # - ip_address: String - IP Address where the request comes from
  # If user doesn't exist or wrong password: raise UnauthorizedException
  #
  # White-listed approach for the Permission: 
  # - If user has no rule: Return empty array, deny everything from all IP addresses.
  # - If user has some allowed rules and some denied rules: We care for only allowed rules for the request ip, deny everything else.
  # - If user has only denied rules: Deny everything.
  def self.authenticate(username, password, ip_address)
    user = User.includes(:rules).find_by(username: username)
    raise UnauthorizedException.new(UNAUTHORIZED_MESSAGE) unless user&.authenticate(password)
    user.set_allowed_rules(ip_address)
    user
  end
end




                         