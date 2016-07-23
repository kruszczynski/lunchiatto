# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    name 'Bartek Szef'
    email 'bartek@test.net'
    password 'jacekjacek'
    factory :admin_user do
      company_admin true
    end
  end

  factory :other_user, class: User do
    name 'Kruszcz Puszcz'
    email 'krus@test.net'
    password 'password'
  end

  factory :yet_another_user, class: User do
    sequence(:email) { |n| "kruszczu#{n}@test.net" }
    sequence(:name) { |n| "kruszczu#{n}" }
    password 'password'
  end
end
