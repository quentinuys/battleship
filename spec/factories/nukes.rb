# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nuke do
    x_position 1
    y_position 1
    status "MyString"
    nukeable_id 1
    nukeable_type "MyString"
  end
end
