# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "MyString"
    last_name "MyString"
    first_name_kana "MyString"
    last_name_kana_string "MyString"
    email "MyString"
    password_digest "MyString"
  end
end
