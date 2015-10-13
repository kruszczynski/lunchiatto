task :load_seeds, [:user_email] => :environment do |t, args|
  require 'faker'
  require 'faker/company'
  I18n.reload! # reload faker translations
  include FactoryGirl::Syntax::Methods
  find_and_update_user! args

  @users = [@user, @mock_user, @mock_other_user]
  2.times do
    create_order @user
    create_order @mock_user
  end
end

def find_and_update_user!(args)
  email = args[:user_email]
  raise 'Missing email argument!' unless email
  @user = User.find_by email: email
  raise "User #{email} not found!" unless @user

  @user.update account_number: '1234123412341234'
  create_users
end

def create_users
  [:user, :other_user].each do |factory_name|
    instance_variable_set("@mock_#{factory_name}", User.create!(attributes_for(factory_name)))
  end
end

def create_order(user)
  order = user.orders.create!(attributes_for(:past_order, from: Faker::Company.name))
  add_dishes order
  order.change_status(:ordered)
  order.change_status(:delivered)
  order.save!
end

def add_dishes(order)
  @users.each do |user|
    order.dishes.create(attributes_for(:dish, user: user, name: Faker::Company.catch_phrase, price: Money.new(Random.new.rand(2000..4000), 'PLN')))
  end
end