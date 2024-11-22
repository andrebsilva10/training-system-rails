require "application_system_test_case"

class UserUpdatePasswordTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    sign_in(@user)
  end

  test "can update password" do
    visit users_edit_password_path

    within("form#user_update_password_form") do
      fill_in :user_current_password, with: @user.password
      fill_in :user_password, with: "newpassword"
      fill_in :user_password_confirmation, with: "newpassword"

      click_on I18n.t("sessions.actions.reset_password")
    end

    assert_alert I18n.t("users.profile.update_password.success")
  end

  test "cannot update password with mismatched passwords" do
    visit users_edit_password_path

    within("form#user_update_password_form") do
      fill_in :user_current_password, with: @user.password
      fill_in :user_password, with: "newpassword"
      fill_in :user_password_confirmation, with: "mismatchedpassword"

      click_on I18n.t("sessions.actions.reset_password")
    end

    within("form#user_update_password_form") do
      assert_selector "p", text: I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
    end
  end

  test "cannot update password with empty fields" do
    visit users_edit_password_path

    within("form#user_update_password_form") do
      fill_in :user_current_password, with: @user.password
      click_on I18n.t("sessions.actions.reset_password")

      assert_selector "p", text: I18n.t("errors.messages.confirmation", attribute: User.human_attribute_name(:password))
      assert_selector "p", text: I18n.t("errors.messages.blank")
    end
  end
end
