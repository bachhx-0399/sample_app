class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed,
                              items: Settings.digits.length_30
  end

  def help; end

  def about; end

  def contact; end
end
