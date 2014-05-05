# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    battleship_id 1
    name "MyString"
    email "MyString"
    game_status "MyString"
    prize "MyString"
  end
end
