# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    name 'Bartek Szef'
    sequence :email do |n|
      "bartek#{n}@test.net"
    end
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
end
