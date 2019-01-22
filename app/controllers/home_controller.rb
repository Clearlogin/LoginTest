class HomeController < ApplicationController
  def home
    @rules = current_user.set_allowed_rules(request.remote_ip)
    @remote_ip = request.remote_ip
  end
end
