module ApplicationHelper
  def field_with_errors(object, field_name)
    css_class = 'error' if object.errors[field_name].present?
    content_tag(:label, class: css_class) do
      res = yield
      if css_class
        res += content_tag(:small, class: 'error') do
          object.errors.full_messages_for(field_name).join(', ')
        end
      end
      res.html_safe
    end
  end
end
