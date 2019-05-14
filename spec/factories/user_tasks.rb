FactoryBot.define do
  factory :user_task do
    association :user
    association :task
  end
end
