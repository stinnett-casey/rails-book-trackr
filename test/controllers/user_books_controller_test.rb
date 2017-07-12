require 'test_helper'

class UserBooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_books_index_url
    assert_response :success
  end

  test "should get new" do
    get user_books_new_url
    assert_response :success
  end

  test "should get create" do
    get user_books_create_url
    assert_response :success
  end

  test "should get show" do
    get user_books_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_books_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_books_update_url
    assert_response :success
  end

  test "should get destroy" do
    get user_books_destroy_url
    assert_response :success
  end

end
