class Task < ApplicationRecord

  attr_accessor :debtor_id

  enum status: { waiting: 0, working: 1, completed: 2 }
  enum priority: { low: 0, middle: 1, high: 2 }

  belongs_to :group
  has_many :labels, dependent: :destroy
  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks

  validates :name, presence: true
  validates :deadline, presence: true
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  scope :default_order, -> { order(created_at: :desc) }
  scope :where_like_name, -> (name) { where('tasks.name like ?', "%#{name}%") }
  scope :where_eql_status, -> (status) { where(status: status) }
  scope :where_eql_priority, -> (priority) { where(priority: priority) }
  scope :where_eql_label_ids, -> (label_ids) { joins(:labels).merge(Label.where(id: label_ids)) }
  scope :where_eql_group_id, -> (group_id) { joins(:group).merge(Group.where(id: group_id)) }
  scope :where_eql_task_role, -> (task_role) { joins(:user_tasks).merge(UserTask.where(task_role: task_role)) }
  scope :only_related_with_user, -> (user_id) { where(user_id: user_id) }

  mount_uploader :image, ImageUploader

  def create_labels(new_labels)
    new_labels.each do |label|
      self.labels.find_or_create_by(name: label)
    end
  end

  def delete_labels(new_labels)
    delete_labels = self.labels.map(&:name) - new_labels
    self.labels.where(name: delete_labels).destroy_all
  end

  def update_labels(new_labels)
    self.create_labels(new_labels)
    self.delete_labels(new_labels)
  end

  def is_passed_deadline?
    deadline < Time.zone.today
  end

  def is_deadline_in_3_days?
    diff_from_today <= 3
  end

  def has_notice?
    read_datestamp != Time.zone.today && (is_passed_deadline? || is_deadline_in_3_days?)
  end

  def create_with_user(debtee_id, debtor_id)
    self.user_tasks.build(user_id: debtee_id, task_role: 'debtee')
    self.user_tasks.build(user_id: debtor_id, task_role: 'debtor')
    self.save
  end

  def find_user_by_task_role(task_role)
    self.user_tasks.find_by(task_role: task_role).user
  end

  def diff_from_today
    (deadline - Time.zone.today).to_i
  end

  def get_debtee
    self.user_tasks.find_by(task_role: 'debtee').user
  end

  def self.get_notice_tasks(user)
    tasks = Task.extract_not_completed(user.tasks)
    if tasks.present?
      Task.extract_has_notice(tasks)
    end
  end

  def self.extract_not_completed(tasks)
    tasks.map { |task| task unless task.completed? }.compact
  end

  def self.extract_has_notice(tasks)
    tasks.map { |task| task if task.has_notice? }.compact
  end

  def self.remind_tasks_deadline
    today = Time.zone.today
    user_tasks = UserTask.where(task_role: 'debtor').joins(:task).merge(Task.where.not(status: 'completed').where(deadline: today..today.since(3.days)))
    user_tasks.each do |user_task|
      TaskMailer.remind_task(user_task.user, user_task.task).deliver_now
    end
  end

  private
    def remove_debtee(user_ids, debtee_id)
      user_ids.delete(debtee_id)
      user_ids
    end
end
