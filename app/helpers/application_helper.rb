module ApplicationHelper
  ActionView::Base.default_form_builder = TailwindFormBuilder

  def full_title(page_title = "", base_title = t("app.name"))
    if page_title.nil? || page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def rc(component_string, **args, &block)
    component_class_name = component_string.split("\\").map(&:camelcase).join("::")

    unless component_class_name.include? "::"
      component_class_name = "#{component_class_name}::Standard"
    end

    render "#{component_class_name}::Component".constantize.new(**args), &block
  end

  def active_button_to(name, path, options = {})
    active_classes = "border-b-2 border-blue-600"
    options[:class] ||= ""
    options[:class] += " #{active_classes}" if current_page?(path)
    button_to name, path, options
  end
end
