FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { 'password' }
  end

  factory :client do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end

  factory :sale do
    client
    value { rand(10..500) }
    sold_at { Faker::Date.between(from: 30.days.ago, to: Date.today) }
  end
end
