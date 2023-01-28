FactoryBot.define do
  factory :ingredient do
    grocery
    meal
    unit_type { "MyString" }
    quantity { "MyString" }
    note { "MyString" }
  end
end
