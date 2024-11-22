require "test_helper"

class UserUpdateWithPasswordTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
  end

  test "should update user with correct current password" do
    assert @user.update_with_password(current_password: "password", name: "New Name")
    assert_equal "New Name", @user.reload.name
  end

  test "should not update user with incorrect current password" do
    assert_not @user.update_with_password(current_password: "wrongpassword", name: "New Name")
    assert_not_equal "New Name", @user.reload.name
    assert_includes @user.errors[:current_password], I18n.t("activerecord.errors.messages.wrong_current_password")
  end

  test "should assign attributes but not save with incorrect current password" do
    @user.update_with_password(current_password: "wrongpassword", name: "New Name")
    assert_equal "New Name", @user.name
    assert_not_equal "New Name", @user.reload.name
  end
end
