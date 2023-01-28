FactoryBot.define do
  factory :meal_template do
    name { "MyString" }
    description { "MyText" }
    serving_for { 1 }
    prep_time { 1 }
    cook_time { 1 }
    total_time { 1 }

    trait :with_ingredients do
      after(:create) do |meal_template|
        grocery_category = create(:grocery_category)
        3.times do |t|
          grocery = create(:grocery, name: "grocery #{t}", grocery_category: grocery_category)
          create(:ingredient_template, grocery: grocery, meal_template: meal_template)
        end
      end
    end
  end
end
