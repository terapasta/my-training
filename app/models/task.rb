class Task < ApplicationRecord
  enum status: { waiting: 0, working: 1, completed: 2 }
  enum priority: { low: 0, middle: 1, high: 2 }

  belongs_to :user
  counter_culture :user
  belongs_to :group, optional: true
  has_many :labels, dependent: :destroy

  validates :name, presence: true
  validates :deadline, presence: true
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  scope :default_order, -> { order(created_at: :desc) }
  scope :where_like_name, -> (name) { where('name like ?', "%#{name}%") }
  scope :where_eql_status, -> (status) { where(status: status) }
  scope :where_eql_priority, -> (priority) { where(priority: priority) }
  scope :where_eql_label_ids, -> (label_ids) { joins(:labels).merge(Label.where(id: label_ids)) }
  scope :only_related_with_user, -> (user_id) { where(user_id: user_id) }

  def create_labels(new_labels)
    if new_labels.present?
      new_labels.split(',').each do |label|
        self.labels.create(name: label) unless self.labels.pluck(:name).include?(label)  
      end
    end
  end

  def delete_labels(new_labels)
    self.labels.each { |label| label.destroy unless new_labels.include?(label.name) }
  end

  def update_labels(new_labels)
    self.create_labels(new_labels)
    self.delete_labels(new_labels)
  end

  def is_passed_deadline?
    deadline < Date.today
  end

  def is_deadline_in_3_days?
    (deadline - Date.today).to_i <= 3
  end

  def has_notice?
    read_datestamp != Date.today && (is_passed_deadline? || is_deadline_in_3_days?)
  end

  def self.get_notice_tasks(user)
    if (tasks = Task.extract_not_completed(user.tasks)).present?
      Task.extract_has_notice(tasks)
    end
  end

  def self.extract_not_completed(tasks)
    tasks.map { |task| task unless task.completed? }.compact
  end

  def self.extract_has_notice(tasks)
    tasks.map { |task| task if task.has_notice? }.compact
  end
end
