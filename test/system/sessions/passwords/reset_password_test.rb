require "application_system_test_case"

class ResetPasswordTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
  end

  test "user can reset password with valid token" do
    token = @user.password_reset_token

    visit edit_password_path(token)

    fill_in :user_password, with: "newpassword"
    fill_in :user_password_confirmation, with: "newpassword"

    click_on I18n.t("sessions.actions.reset_password")

    assert_current_path new_session_path
  end

  test "cannot reset password with invalid token" do
    visit edit_password_path("invalidtoken")

    assert_alert I18n.t("sessions.flash.token_invalid")
    assert_current_path new_password_path
  end

  test "cannot reset password with mismatched passwords" do
    token = @user.password_reset_token

    visit edit_password_path(token)

    fill_in :user_password, with: "newpassword"
    fill_in :user_password_confirmation, with: "differentpassword"

    click_on I18n.t("sessions.actions.reset_password")

    within("form") do
      assert_selector "p", text: I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
    end

    assert_current_path edit_password_path(token)
  end

  test "cannot reset password with empty fields" do
    token = @user.password_reset_token

    visit edit_password_path(token)

    click_on I18n.t("sessions.actions.reset_password")

    within("form") do
      assert_selector "p", text: I18n.t("errors.messages.blank")
      assert_selector "p", text: I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
    end

    assert_current_path edit_password_path(token)
  end
end
