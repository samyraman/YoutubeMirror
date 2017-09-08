require 'test_helper'

class TabControllerTest < ActionController::TestCase
  test "should get remote" do
    get :remote
    assert_response :success
  end

end
