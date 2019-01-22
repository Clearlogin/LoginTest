class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]
  rescue_from UnauthorizedException, with: :relogin
  
  def new
    @user = User.new
  end

  def create
    user = Auther.authenticate(params[:user][:username], params[:user][:password], request.remote_ip)
    session['user.id'] = user.id
    redirect_to '/'
  end

  def relogin
    @error = 'Unauthorized. Please try again.'
    @user = User.new
    render template: '/sessions/new', status: :unauthorized
  end
end
