class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password validations: true
  has_many :tasks, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\z/
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,100}+\z/i
  
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true, 
            format: { 
              with: VALID_EMAIL_REGEX,
              message: I18n.t('errors.user.email')
               }, allow_blank: true
  validates :password, presence: true, on: [:create]
  validates :password,
            format: {
              with: VALID_PASSWORD_REGEX,
              message: I18n.t('errors.user.password')
            }, allow_blank: true, on: [:create]

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.encrypt(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
