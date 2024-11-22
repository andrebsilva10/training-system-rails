FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email_address { Faker::Internet.unique.email }
    password { "password" }
    confirmed_at { Time.zone.now }

    factory :unconfirmed_user do
      confirmed_at { nil }
    end
  end
end
