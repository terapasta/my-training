namespace :mailers do
  desc 'リマインドメール'
    task remind_tasks_deadline: :environment do
      Task.remind_tasks_deadline
    end
end
