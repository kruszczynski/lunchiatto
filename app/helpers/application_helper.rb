# Helps Application
module ApplicationHelper
  def field_with_errors(object, field_name)
    css_class = 'error' if object.errors[field_name].present?
    content_tag(:label, class: css_class) do
      (yield + error_message_tag(object, field_name)).html_safe
    end
  end

  # This method smells of :reek:FeatureEnvy
  def error_message_tag(object, field_name)
    error_messages = object.errors.full_messages_for(field_name)
    return '' if error_messages.blank?
    content_tag(:small, class: 'error') do
      error_messages.join(', ')
    end
  end
end
