require 'test_helper'

class AmbassadorsControllerTest < ActionController::TestCase

  def setup
    @ambassador = ambassadors(:lebowski)
    @other_ambassador = ambassadors(:christmas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @ambassador
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @ambassador, ambassador: { first_name: @ambassador.first_name,
                                                  last_name: @ambassador.last_name,
                                                  email: @ambassador.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_ambassador)
    get :edit, id: @ambassador
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_ambassador)
    patch :update, id: @ambassador, ambassador: { first_name: @ambassador.first_name,
                                                  last_name: @ambassador.last_name,
                                                  email: @ambassador.email}
    assert_not flash.empty?
    assert_redirected_to root_url
  end


end
