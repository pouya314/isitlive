require 'test_helper'

class UpdaterControllerTest < ActionController::TestCase
  test "should get msg" do
    get :msg
    assert_response :success
  end

end
