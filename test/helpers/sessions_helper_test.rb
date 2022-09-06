require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @ambassador = ambassadors(:lebowski)
    remember(@ambassador)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @ambassador, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @ambassador.update_attribute(:remember_digest, Ambassador.digest(Ambassador.new_token))
    assert_nil current_user
  end
end
