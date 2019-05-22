class UserTask < ApplicationRecord
  enum task_role: { debtee: 0, debtor: 1 }

  belongs_to :user
  belongs_to :task

  def self.create_user_tasks(task_id, user_ids)
    user_ids.each { |user_id| self.create(task_id: task_id, user_id: user_id, task_role: 'debtor') }
  end
end
