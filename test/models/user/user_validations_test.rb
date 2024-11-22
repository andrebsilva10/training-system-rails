require "test_helper"

class UserValidationsTest < ActiveSupport::TestCase
  subject { @user }
  setup do
    @user = create(:user)
  end

  should validate_presence_of(:name)
  should validate_presence_of(:email_address)
  should validate_uniqueness_of(:email_address).case_insensitive

  should "validate presence of password if password is required" do
    @user.password = nil
    @user.password_confirmation = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], I18n.t("errors.messages.blank")
  end

  should "validate length of password if password is required" do
    @user.password = "short"
    @user.password_confirmation = "short"
    assert_not @user.valid?
    assert_includes @user.errors[:password], I18n.t("errors.messages.too_short", count: 6)
  end

  should "validate confirmation of password if password is required" do
    @user.password = "password"
    @user.password_confirmation = "different"

    attribute = User.human_attribute_name(:password)
    assert_not @user.valid?
    assert_includes @user.errors[:password_confirmation], I18n.t("errors.messages.confirmation", attribute: attribute)
  end

  should "be valid with a proper password" do
    @user.password = "password"
    @user.password_confirmation = "password"
    assert @user.valid?
  end
end
