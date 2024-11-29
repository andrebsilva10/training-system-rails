require "test_helper"

# get "signup", to: "registrations#new", as: :new_registration
# post "signup", to: "registrations#create", as: :registration

# get "confirmation", to: "registrations#confirmation", as: :confirmation
# patch "confirm_account", to: "registrations#confirm_account"
# patch "resend_confirmation", to: "registrations#resend_confirmation"

class Auth::RegistrationsControllerAccessTest < ActionDispatch::IntegrationTest
  context "unauthenticated user" do
    should "access the routes" do
      get new_registration_path
      assert_response :success

      post registration_path, params: { user: { name: "", email_address: "", password: "" } }
      assert_response :unprocessable_entity

      get confirmation_path
      assert_response :success

      patch confirm_account_path, params: { email_address: "", confirmation_code: "" }
      assert_response :unprocessable_entity

      patch resend_confirmation_path, params: { email_address: "a@a.com" }
      assert_redirected_to confirmation_path, params: { email_address: "a@a.com" }
    end
  end

  context "authenticated user" do
    should "be redirect to users_root_path" do
      sign_in create(:user)

      get new_registration_path
      assert_redirected_to users_root_path

      post registration_path, params: { user: { name: "", email_address: "", password: "" } }
      assert_redirected_to users_root_path

      get confirmation_path
      assert_redirected_to users_root_path

      patch confirm_account_path, params: { email_address: "", confirmation_code: "" }
      assert_redirected_to users_root_path

      patch resend_confirmation_path, params: { email_address: "a@a.com" }
      assert_redirected_to users_root_path
    end
  end
end
