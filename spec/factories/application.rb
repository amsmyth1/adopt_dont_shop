FactoryBot.define do
  factory :application do
    first_name { Faker::Name.first_name}
    last_name { Faker::Name.last_name}
    street_address { Faker::Address.street_name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    description { "" }
    status { "In Progress" or "Pending" or "Accepted" or "Rejected" }
    shelter
  end
end
