FactoryBot.define do
  factory :label do
    association :task
    sequence(:name) { |n| "lable#{n}" }
  end
end
