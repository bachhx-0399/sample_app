class FollowersController < UsersController
  before_action :find_user, :logged_in_user, only: :index

  def index
    @title = t ".Followers"
    @pagy, @users = pagy @user.followers
    render "show_follow", status: :unprocessable_entity
  end
end
