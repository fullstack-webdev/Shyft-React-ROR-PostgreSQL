require 'test_helper'

class ShyftPagesControllerTest < ActionController::TestCase
  test "should get request_invite" do
    get :request_invite
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get how_to_hire" do
    get :how_to_hire
    assert_response :success
  end

  test "should get how_to_work" do
    get :how_to_work
    assert_response :success
  end

  test "should get why_shyft" do
    get :why_shyft
    assert_response :success
  end

  test "should get ambassadors" do
    get :ambassadors
    assert_response :success
  end

  test "should get cphollister_profile" do
    get :cphollister_profile
    assert_response :success
  end

  test "should get cphollister_booking" do
    get :cphollister_booking
    assert_response :success
  end

  test "should get confirmation" do
    get :confirmation
    assert_response :success
  end

end
