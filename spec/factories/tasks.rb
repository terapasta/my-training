FactoryBot.define do
  factory :task do
    association :group
    sequence(:name) { |n| "task#{n}" }
    description { '説明説明説明説明説明' }
    deadline { Date.today.since(1.week) }
    status { 'waiting' }
    priority { 'middle' }
  end
end
