class SessionsController < ApplicationController
  before_action :find_user, only: %i(create)
  def new; end

  def create
    if @user.authenticate params.dig(:session, :password)
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      log_in @user
      redirect_to forwarding_url || @user
    else
      flash.now[:danger] = t ".invalid_login"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private
  def find_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return unless @user.nil?

    flash[:danger] = t ".invalid_login"
    redirect_to action: :new
  end
end
