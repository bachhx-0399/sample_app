class SessionsController < ApplicationController
  before_action :find_user, only: :create
  before_action :authenticate_user, only: :create
  def new; end

  def create
    if @user.activated?
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      log_in @user
      redirect_to forwarding_url || @user
    else
      redirect_to root_url, flash: {warning: t(".activated_false")}
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end

  private
  def handle_failed_login
    flash[:danger] = t ".invalid_login"
    redirect_to action: :new, status: :unprocessable_entity
  end

  def find_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return unless @user.nil?

    handle_failed_login
  end

  def authenticate_user
    return if @user.authenticate params.dig(:session, :password)

    handle_failed_login
  end
end
