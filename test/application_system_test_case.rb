require "test_helper"
require "support/helpers/capybara_custom_assertions"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include CapybaraCustomAssertions

  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  def sign_in(user)
    Capybara.reset_sessions!
    visit new_session_path

    fill_in :email_address, with: user.email_address
    fill_in :password, with: "password"
    click_on I18n.t("sessions.actions.sign_in")
    assert_current_path users_root_path
  end
end
