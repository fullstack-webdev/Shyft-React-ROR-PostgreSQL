require 'test_helper'

class BusyShiftControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

end
