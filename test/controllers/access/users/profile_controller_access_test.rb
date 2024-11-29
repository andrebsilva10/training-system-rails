require "test_helper"

# get "profile/edit", to: "profile#edit", as: :edit_profile
# patch "profile/update", to: "profile#update", as: :update_profile
# patch "profile/update_avatar", to: "profile#update_avatar", as: :update_avatar
# delete "profile/delete_avatar", to: "profile#delete_avatar", as: :delete_avatar
# get "profile/edit_password", to: "profile#edit_password", as: :edit_password
# patch "profile/update_password", to: "profile#update_password", as: :update_password
class Users::HomeControllerAccessTest < ActionDispatch::IntegrationTest
  context "unauthenticated user" do
    should "redirect to new_session_path" do
      get users_root_path
      assert_redirected_to new_session_path

      get users_edit_profile_path
      assert_redirected_to new_session_path

      patch users_update_profile_path
      assert_redirected_to new_session_path

      delete users_delete_avatar_path
      assert_redirected_to new_session_path

      get users_edit_password_path
      assert_redirected_to new_session_path

      patch users_update_password_path
      assert_redirected_to new_session_path
    end
  end

  context "authenticated user" do
    should "access the routes" do
      user = create(:user)
      sign_in(user)

      get users_edit_profile_path
      assert_response :success

      user_params = { user: { name: user.name,
                              email_address: user.email_address,
                              current_password: "password" } }
      patch users_update_profile_path, params: user_params
      assert_redirected_to users_edit_profile_path

      delete users_delete_avatar_path
      assert_redirected_to users_edit_profile_path

      get users_edit_password_path
      assert_response :success

      user_params = { user: { current_password: "password",
                              password: "newpassword",
                              password_confirmation: "newpassword" } }
      patch users_update_password_path, params: user_params
      assert_redirected_to users_edit_password_path
    end
  end
end
