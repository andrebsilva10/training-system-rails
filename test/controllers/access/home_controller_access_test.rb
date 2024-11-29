require "test_helper"

# root "home#index"
class HomeControllerAccessTest < ActionDispatch::IntegrationTest
  context "unauthenticated user" do
    should "access /" do
      get root_url
      assert_response :success
    end
  end
end
