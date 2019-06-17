json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :deadline, :amount, :status, :priority
  json.labels do
    json.array!(task.labels) do |label|
      json.extract! label, :id, :name
    end
  end
  json.group do
    json.extract! task.group, :id, :name
  end
  json.role task.user_tasks.find_by(user_id: current_user.id).task_role
  json.debtor_id task.find_user_by_task_role('debtor').id
end
