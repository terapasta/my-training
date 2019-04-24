class User < ApplicationRecord
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
  validates :password_digest, presence: true
  validates :password_digest,
            format: {
              with: VALID_PASSWORD_REGEX,
              message: I18n.t('errors.user.password')
            }, allow_blank: true
end
