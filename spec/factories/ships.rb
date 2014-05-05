# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship do
    name "MyString"
    size 1
    status "MyString"
    location_x 1
    location_y 1
    direction "MyString"
    shipable_id 1
    shipable_type "MyString"
  end
end
