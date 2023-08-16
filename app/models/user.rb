class User < ApplicationRecord
  before_save{self.email = email.downcase}
  validates :name, presence: true,
            length: {maximum: Settings.digits.length_50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            length: {maximum: Settings.digits.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :password, presence: true,
            length: {minimum: Settings.digits.length_6}
  has_secure_password
end
