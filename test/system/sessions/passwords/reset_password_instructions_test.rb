require "application_system_test_case"

class ResetPasswordInstructionsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = create(:user)
    ActionMailer::Base.deliveries.clear
  end

  test "user can ask instructions to reset password" do
    perform_enqueued_jobs do
      visit new_password_path

      fill_in :email_address, with: @user.email_address
      click_on I18n.t("sessions.actions.send_reset_password_instructions")

      assert_current_path new_session_path

      assert_alert I18n.t("sessions.flash.send_reset_password_instructions")

      assert_equal 1, ActionMailer::Base.deliveries.size
      email = ActionMailer::Base.deliveries.last
      assert_equal [ @user.email_address ], email.to
      assert_equal I18n.t("mailer.reset_password.subject"), email.subject
    end
  end

  test "user can navigate to forgot password page" do
    visit new_password_path

    click_on I18n.t("sessions.actions.back_to_sign_in")

    assert_current_path new_session_path
  end
end
