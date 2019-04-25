class Task < ApplicationRecord
  enum status: { waiting: 0, working: 1, completed: 2 }
  enum priority: { high: 1, middle: 2, low: 3, unselected: 10 }

  belongs_to :user

  validates :name, presence: true
  validates :deadline, presence: true
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  PRIORITY_ORDERS = [1, 2, 3, 10]

  scope :default_order, -> { order(created_at: :desc) }
  scope :where_like_name, -> (name) { where('name like ?', "%#{name}%") }
  scope :where_eql_status, -> (status) { where(status: status) }
  scope :where_eql_priority, -> (priority) { where(priority: priority) }
  scope :order_by_priority, -> (direction) do
    order_by = [] 
    PRIORITY_ORDERS.each { |priority| order_by << "priority=#{priority} #{direction}" }
    order(Arel.sql(order_by.join(", ")))
  end

  def self.task_order(tasks, sort_column, sort_direction)
    case sort_column
    when 'priority'
      tasks = tasks.order_by_priority(sort_direction)
    else
      tasks = tasks.order("#{sort_column} #{sort_direction}")
    end
    tasks
  end
end
