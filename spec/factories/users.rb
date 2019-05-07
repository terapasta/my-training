FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "email#{n}@sample.com" }
    sequence(:password_digest) { |n| "password#{n}" }
  end
end
