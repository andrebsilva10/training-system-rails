require "test_helper"

# root "home#dashboard"
class Users::HomeControllerAccessTest < ActionDispatch::IntegrationTest
  context "unauthenticated user" do
    should "redirect to new_session_path" do
      get users_root_url
      assert_redirected_to new_session_path
    end
  end

  context "authenticated user" do
    should "access the routes" do
      sign_in create(:user)
      get users_root_url
      assert_response :success
    end
  end
end
