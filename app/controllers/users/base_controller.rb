class Users::BaseController < ActionController::Base
  include Authentication
  include ::Breadcrumbs
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types :success, :warning

  layout "users/application"

  before_action :default_breadcrumbs

  private

  def default_breadcrumbs
    add_breadcrumb I18n.t("breadcrumbs.home"), users_root_path
    set_breadcrumbs if respond_to?(:set_breadcrumbs, true)
  end
end
