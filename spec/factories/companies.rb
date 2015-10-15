FactoryGirl.define do
  factory :company do
    name 'MyString'
  end

  factory :other_company, class: Company do
    name 'The Other Company'
  end
end
