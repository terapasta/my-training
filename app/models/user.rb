class User < ApplicationRecord
  attr_accessor :remember_token

  enum role: { normal: 0, admin: 1 }

  has_secure_password validations: true

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :user_tasks, dependent: :destroy
  has_many :tasks, through: :user_tasks

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

  mount_uploader :image, ImageUploader

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine::DEFAULT_COST
    BCrypt::Password.create(token, cost: cost)
  end

  def self.get_ids_by_emails(emails)
    User.where(email: emails).pluck(:id)
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

  def user_task_debtee?(task_id)
    self.user_tasks.find_by(task_id: task_id).task_role == 'debtee'
  end

  def count_tasks_by_role(counting_role)
    self.user_tasks.pluck(:task_role).count { |role| role == counting_role }
  end
end
