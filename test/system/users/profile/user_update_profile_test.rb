require "application_system_test_case"

class UserUpdateProfileTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    sign_in(@user)
    @form = "form[action='#{users_update_profile_path}']"
  end

  test "user can view profile page" do
    visit users_edit_profile_path

    assert_selector "h1", text: I18n.t("users.profile.edit.title")

    within("nav#breadcrumbs") do
      assert_link I18n.t("breadcrumbs.home"), href: users_root_path
      assert_text I18n.t("breadcrumbs.profile")
    end

    within(@form) do
      assert_field :user_name, with: @user.name
      assert_field :user_email_address, with: @user.email_address
      assert_field :user_current_password, with: ""
    end
  end

  test "user can update profile" do
    visit users_edit_profile_path

    fill_in :user_name, with: "New Name"
    fill_in :user_email_address, with: "new.email@test.com"
    fill_in :user_current_password, with: "password"
    click_on I18n.t("buttons.update")

    assert_current_path users_edit_profile_path
    assert_alert I18n.t("users.profile.update.success")

    within(@form) do
      assert_field :user_name, with: "New Name"
      assert_field :user_email_address, with: "new.email@test.com"
    end
  end

  test "user cannot update profile with invalid data" do
    visit users_edit_profile_path

    fill_in :user_name, with: ""
    fill_in :user_email_address, with: ""
    fill_in :user_current_password, with: "password"
    click_on I18n.t("buttons.update")

    assert_current_path users_edit_profile_path

    within(@form) do
      assert_selector "p", text: I18n.t("errors.messages.blank"), count: 2
    end
  end

  test "user cannot update profile with invalid password" do
    visit users_edit_profile_path

    fill_in :user_name, with: "New Name"
    fill_in :user_email_address, with: @user.email_address
    fill_in :user_current_password, with: "wrongpassword"
    click_on I18n.t("buttons.update")

    assert_current_path users_edit_profile_path

    within(@form) do
      assert_selector "p", text: I18n.t("activerecord.errors.messages.wrong_current_password")
    end
  end
end
