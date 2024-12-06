module ApplicationHelper
  ActionView::Base.default_form_builder = TailwindFormBuilder

  def full_title(page_title = "", base_title = t("app.name"))
    if page_title.nil? || page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def flash_class_type(flash_type)
    { notice: "p-4 mb-4 text-sm text-blue-800 rounded-lg bg-blue-50 dark:bg-gray-800 dark:text-blue-400",
      alert: "p-4 mb-4 text-sm text-red-800 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400",
      success: "p-4 mb-4 text-sm text-green-800 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400",
      warning: "p-4 mb-4 text-sm text-yellow-800 rounded-lg bg-yellow-50 dark:bg-gray-800 dark:text-yellow-300"
    }[flash_type.to_sym] || "alert-#{flash_type}"
  end

  def active_button_to(name, path, options = {})
    active_classes = "border-b-2 border-blue-600"
    options[:class] ||= ""
    options[:class] += " #{active_classes}" if current_page?(path)
    button_to name, path, options
  end
end
