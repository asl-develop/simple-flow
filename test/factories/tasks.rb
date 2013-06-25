# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    title ""
    content "MyString"
    charge_user 1
    state 1
    locked 1
    flow "MyString"
    author 1
  end
end
