require 'test_helper'

class AmbassadorsSignupTest < ActionDispatch::IntegrationTest
  test "valid signup information" do
    get ambassadors_signup_path
    assert_difference 'Ambassador.count', 1 do
      post_via_redirect ambassadors_path, ambassador: { first_name:  "Example",
                               last_name:  "User",
                               email: "user@example.com",
                               password:              "password",
                               password_confirmation: "password" }
                             end
    # assert_template 'ambassadors/edit'
    # assert is_logged_in?
  end
end
