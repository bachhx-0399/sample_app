class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.by_earliest_created,
                         items: Settings.digits.length_30
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.microposts,
                              items: Settings.digits.length_30
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".create_info"
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy_success"
      redirect_to users_url, status: :see_other
    else
      flash[:danger] = t ".destroy_danger"
      redirect_to users_url, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id] || params[:user_id]
    redirect_to :root, flash: {warning: t(".user_not_found")} if @user.nil?
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    find_user
    redirect_to root_url, status: :see_other unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_url, status: :see_other unless current_user.admin?
  end
end
