class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      redirect_to root_url, flash: {success: t(".flash_create_success")}
    else
      @pagy, @feed_items = pagy current_user.feed,
                                items: Settings.digits.length_30
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".flash_destroy_success"
    else
      flash[:danger] = t ".flash_destroy_danger"
    end
    redirect_to request.referer || root_url, status: :see_other
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t ".flash_correct_user_danger"
    redirect_to root_url, status: :see_other
  end
end
