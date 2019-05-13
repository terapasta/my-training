class User < ApplicationRecord
  attr_accessor :remember_token

  enum role: { normal: 0, admin: 1 }

  has_secure_password validations: true

  has_many :tasks, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

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
  validates :role, presence: true, inclusion: { in: User.roles.keys }

  scope :only_admin, -> { where(role: :admin) }

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def self.get_ids_by_emails(emails)
    emails = emails.map { |email| User.find_by(email: email)&.id }
    emails.include?(nil) ? false : emails.compact
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

  def last_admin?
    self.admin? && User.only_admin.size <= 1
  end
end
