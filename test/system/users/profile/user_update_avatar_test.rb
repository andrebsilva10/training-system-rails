require "application_system_test_case"

class UserUpdateProfileTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    sign_in(@user)
  end

  test "can view avatar" do
    visit users_edit_profile_path

    avatar_path = ActionController::Base.helpers.asset_path("avatars/default_avatar.png")
    assert_selector "img[src*='#{avatar_path}']"
  end

  test "can update avatar" do
    visit users_edit_profile_path

    within('form[id^="user_update_avatar"]') do
      click_on "Edit"
      assert_selector 'button[data-avatar-preview-target="check"]', visible: true

      find('label[for="user_avatar_upload').click
      assert_selector 'input[type="file"]', visible: false

      attach_file :user_avatar_upload, avatar_path, make_visible: true

      find('button[type="submit"]').click
    end
  end

  test "admin can delete avatar" do
    visit users_edit_profile_path

    within('form[id^="user_update_avatar"]') do
      click_on "Edit"

      assert_selector 'a[data-avatar-preview-target="trash"]', visible: false

      find('a[data-avatar-preview-target="trash"]').click
    end
  end

  def avatar_path
    Rails.root.join("test/factories/files/avatar.png")
  end
end
