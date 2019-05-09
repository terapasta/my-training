class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options = {})
    super + error(attribute)
  end

  def text_area(attribute, options = {})
    super + error(attribute)
  end

  def number_field(attribute, options = {})
    super + error(attribute)
  end

  def telephone_field(attribute, options = {})
    super + error(attribute)
  end

  def email_field(attribute, options = {})
    super + error(attribute)
  end

  def password_field(attribute, options = {})
    super + error(attribute)
  end

  def date_field(attribute, options = {})
    super + error(attribute)
  end

  def collection_select(attribute, collection, value_attribute, text_attribute, options = {}, html_options = {})
    super + error(attribute)
  end

  def collection_radio_buttons(attribute, collection, value_attribute, text_attribute, options = {}, html_options = {}, &block)
    super + error(attribute)
  end

  private

  def error(attribute)
    error_html(error_message(attribute))
  end

  def error_message(attribute)
    (@object.errors[attribute].size > 0) ? "↑" + I18n.t("activerecord.attributes.#{@object.model_name.singular}.#{attribute}") + @object.errors[attribute].first : ""
  end

  def error_html(msg)
    return "" unless msg.present?

    @template.content_tag(:div, class: "validation-msg-background") do
      @template.concat (@template.content_tag(:span, class: "help-block") do
        msg
      end)
    end
  end
end    
