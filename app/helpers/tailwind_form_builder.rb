class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper

  def tw_text_field(field, options = {})
    options[:class] = "#{input_class(field)} #{options[:class]}"
    input_html = text_field(field, options)

    content_tag(:div, class: "mb-4") do
      label_html(field, options) + input_html + error_message(field)
    end
  end

  def tw_email_field(field, options = {})
    options[:class] = "#{input_class(field)} #{options[:class]}"
    input_html = email_field(field, options)

    content_tag(:div, class: "mb-4") do
      label_html(field, options) + input_html + error_message(field)
    end
  end

  def tw_password_field(field, options = {})
    options[:class] = "#{input_class(field)} #{options[:class]}"
    input_html = password_field(field, options)

    content_tag(:div, class: "mb-4") do
      label_html(field, options) + input_html + error_message(field)
    end
  end

  def tw_submit(value = I18n.t("buttons.save"), options = {})
    default_class = "px-6 py-2 text-sm font-medium tracking-wide text-white transition-colors duration-300 transform bg-blue-500 rounded-lg hover:bg-blue-400 focus:outline-none focus:ring focus:ring-blue-300 focus:ring-opacity-50"
    options[:class] = "#{default_class} #{options[:class]}".strip
    content_tag(:div, class: "flex justify-end") do
      submit(value, options)
    end
  end

  private

  def input_class(field)
    "#{error_input_class(field)} mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
  end

  def label_text(label_text, field)
    label_text || object&.class&.human_attribute_name(field) || I18n.t("form.fields.#{field}")
  end

  def label_html(field, options)
    label_text = label_text(options[:label], field)
    label(field, label_text, class: "block text-sm font-medium text-gray-700")
  end

  # Errors
  # --------------------------------------------------------------
  def error_input_class(field)
    "border border-red-500" if object && object.errors[field].any?
  end

  def error_message(field)
    if object && object.errors[field].any?
      content_tag(:p, object.errors[field].first, class: "text-red-600 text-sm mt-1")
    else
      "".html_safe
    end
  end
end
