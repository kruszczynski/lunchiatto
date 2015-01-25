FactoryGirl.define do
  factory :user do |user|
    user.name 'Bartek Szef'
    user.email 'bartek@test.net'
    user.password 'jacekjacek'
  end

  factory :other_user, class: User do |user|
    user.name 'Kruszcz Puszcz'
    user.email 'krus@test.net'
    user.password 'password'
  end
end