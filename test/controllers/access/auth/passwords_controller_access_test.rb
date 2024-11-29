require "test_helper"

# resources :passwords, param: :token, except: %i[ index show ]
class Auth::PasswordsControllerAccessTest < ActionDispatch::IntegrationTest
  context "unauthenticated user" do
    should "access the routes" do
      get new_password_path
      assert_response :success

      post passwords_path
      assert_redirected_to new_session_path

      get edit_password_path(token: "token")
      assert_redirected_to new_password_path

      patch password_path(token: "token"), params: { password: "password", password_confirmation: "password" }
      assert_redirected_to new_password_path
    end
  end

  context "authenticated user" do
    should "be redirect to users_root_path" do
      sign_in create(:user)

      get new_password_path
      assert_redirected_to users_root_path

      post passwords_path
      assert_redirected_to users_root_path

      get edit_password_path(token: "token")
      assert_redirected_to users_root_path

      patch password_path(token: "token"), params: { password: "password", password_confirmation: "password" }
      assert_redirected_to users_root_path
    end
  end
end
