FactoryBot.define do
    factory :event do
      name { Faker::Company.name }
      start_at { rand(1..100).days.from_now }
      location { Faker::Restaurant.name }
      status {'draft'}
      duration {rand(1..10)}
      user_id nil
    end
  end