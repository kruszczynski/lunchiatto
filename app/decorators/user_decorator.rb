class UserDecorator < Draper::Decorator
  delegate_all

  def company_name
    company.name
  end
end
