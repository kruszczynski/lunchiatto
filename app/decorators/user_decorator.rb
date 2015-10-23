class UserDecorator < Draper::Decorator
  delegate_all

  # Usage def company_name
  delegate :name, to: :company, prefix: true
end
