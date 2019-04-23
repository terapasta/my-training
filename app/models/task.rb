class Task < ApplicationRecord
  enum status: { waiting: 0, working: 1, completed: 2 }
  enum priority: { high: 1, middle: 2, low: 3, unselected: 10 }

  validates :name, presence: true
  validates :deadline, presence: true
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  scope :default_order, -> { order(created_at: :desc) }
  scope :where_like_name, -> (name) { where('name like ?', "%#{name}%") }
  scope :where_eql_status, -> (status) { where(status: status) }
end
