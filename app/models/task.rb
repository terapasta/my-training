class Task < ApplicationRecord
  enum status: { waiting: 0, working: 1, completed: 2 }
  enum priority: { low: 0, middle: 1, high: 2 }

  belongs_to :user
  counter_culture :user
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
end
