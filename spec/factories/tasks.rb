FactoryBot.define do
  factory :task do
    association :group
    sequence(:name) { |n| "task#{n}" }
    description { '説明説明説明説明説明' }
    deadline { Time.zone.today.since(1.week) }
    amount { 1000 }
    status { 'waiting' }
    priority { 'middle' }
  end
end
