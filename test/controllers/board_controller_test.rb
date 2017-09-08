require 'test_helper'

class BoardControllerTest < ActionController::TestCase
  test "should get mirror" do
    get :mirror
    assert_response :success
  end

end
