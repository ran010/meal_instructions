FactoryBot.define do
  factory :meal do
    name { "MyString" }
    bookmark { false }
    serving_for { 1 }
    ingredients_count { 1 }
    user
  end
end
