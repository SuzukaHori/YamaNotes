require "test_helper"

class WalksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get walks_new_url
    assert_response :success
  end

  test "should get show" do
    get walks_show_url
    assert_response :success
  end

  test "should get create" do
    get walks_create_url
    assert_response :success
  end

  test "should get update" do
    get walks_update_url
    assert_response :success
  end

  test "should get delete" do
    get walks_delete_url
    assert_response :success
  end
end
