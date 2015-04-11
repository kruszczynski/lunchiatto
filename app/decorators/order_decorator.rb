class OrderDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all

  DELIVER_TEXT = 'Did you remember to add shipping cost?'

  def current_user_ordered?
    dishes.find_by(user: current_user).present?
  end

  def ordered_by_current_user?
    user == current_user
  end

  def deletable?
    in_progress? && ordered_by_current_user?
  end
end