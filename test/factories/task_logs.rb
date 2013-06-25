# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_log do
    user nil
    task nil
    action 1
  end
end
