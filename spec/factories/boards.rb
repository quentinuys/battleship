# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :board do
    height 1
    width 1
    grid_width 1
    grid_height 1
    boardable_id 1
    boardable_type "MyString"
  end
end
