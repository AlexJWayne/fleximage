require File.dirname(__FILE__) + '/../test_helper'

class AvatarsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:avatars)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_avatar
    assert_difference('Avatar.count') do
      post :create, :avatar => { }
    end

    assert_redirected_to avatar_path(assigns(:avatar))
  end

  def test_should_show_avatar
    get :show, :id => avatars(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => avatars(:one).id
    assert_response :success
  end

  def test_should_update_avatar
    put :update, :id => avatars(:one).id, :avatar => { }
    assert_redirected_to avatar_path(assigns(:avatar))
  end

  def test_should_destroy_avatar
    assert_difference('Avatar.count', -1) do
      delete :destroy, :id => avatars(:one).id
    end

    assert_redirected_to avatars_path
  end
end
