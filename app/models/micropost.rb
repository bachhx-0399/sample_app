class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :recent_posts, ->{order(created_at: :desc)}
  scope :by_user_ids, ->(user_ids){where user_id: user_ids}

  validates :content, presence: true,
            length: {maximum: Settings.digits.length_140}
  validates :image, content_type: {in: Settings.model.image_type,
                                   message: I18n.t(".content_type_message")},
                    size: {less_than: 5.megabytes,
                           message: I18n.t(".size_message")}

  delegate :name, to: :user, prefix: true, allow_nil: true

  def display_image
    image.variant resize_to_limit: Settings.model.image_size_limit
  end
end
