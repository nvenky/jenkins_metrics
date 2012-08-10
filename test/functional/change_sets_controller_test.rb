require 'test_helper'

class ChangeSetsControllerTest < ActionController::TestCase
  setup do
    @change_set = change_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:change_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create change_set" do
    assert_difference('ChangeSet.count') do
      post :create, change_set: { change_type: @change_set.change_type, file_name: @change_set.file_name }
    end

    assert_redirected_to change_set_path(assigns(:change_set))
  end

  test "should show change_set" do
    get :show, id: @change_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @change_set
    assert_response :success
  end

  test "should update change_set" do
    put :update, id: @change_set, change_set: { change_type: @change_set.change_type, file_name: @change_set.file_name }
    assert_redirected_to change_set_path(assigns(:change_set))
  end

  test "should destroy change_set" do
    assert_difference('ChangeSet.count', -1) do
      delete :destroy, id: @change_set
    end

    assert_redirected_to change_sets_path
  end
end
