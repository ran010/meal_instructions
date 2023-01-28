FactoryBot.define do
  factory :grocery do
    name { Faker::Name.unique }
    grocery_category
  end
end
