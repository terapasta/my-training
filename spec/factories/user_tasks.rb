FactoryBot.define do
  factory :user_task do
    association :user
    association :task
    task_role { 'debtor' }
  end
end
