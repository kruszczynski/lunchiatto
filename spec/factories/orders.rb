# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    date Date.today
    from 'The best restaurant'
    user nil

    factory :past_order do
      sequence :date do |n|
        Date.today - 2 * n.days
      end
    end
  end
end