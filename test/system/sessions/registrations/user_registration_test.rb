require "application_system_test_case"

class UserRegistrationTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = build(:user)
    visit new_registration_path
  end

  test "user can register" do
    perform_enqueued_jobs do
      ActionMailer::Base.deliveries.clear

      fill_in :user_name, with: @user.name
      fill_in :user_email_address, with: @user.email_address
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"

      click_on I18n.t("sessions.actions.register")
      assert_current_path confirmation_path(email_address: @user.email_address)
      assert_alert(I18n.t("sessions.flash.confirmation_code_sent"))

      assert_equal 1, ActionMailer::Base.deliveries.size
      email = ActionMailer::Base.deliveries.last
      assert_equal [ @user.email_address ], email.to
      assert_equal I18n.t("mailer.account_confirmation.subject"), email.subject
    end
  end

  test "show validations errors" do
    click_on I18n.t("sessions.actions.register")

    within("form") do
      assert_selector "p", text: I18n.t("errors.messages.blank"), count: 3
      assert_selector "p", text: I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
    end

    assert_current_path new_registration_path
  end

  test "user can navigate to new session" do
    click_on I18n.t("sessions.actions.already_have_account")

    assert_current_path new_session_path
  end
end
