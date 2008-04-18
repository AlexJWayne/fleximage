require File.dirname(__FILE__) + '/../test_helper'

class PhotoBaresControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_bares)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_photo_bare
    assert_difference('PhotoBare.count') do
      post :create, :photo_bare => { }
    end

    assert_redirected_to photo_bare_path(assigns(:photo_bare))
  end

  def test_should_show_photo_bare
    get :show, :id => photo_bares(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => photo_bares(:one).id
    assert_response :success
  end

  def test_should_update_photo_bare
    put :update, :id => photo_bares(:one).id, :photo_bare => { }
    assert_redirected_to photo_bare_path(assigns(:photo_bare))
  end

  def test_should_destroy_photo_bare
    assert_difference('PhotoBare.count', -1) do
      delete :destroy, :id => photo_bares(:one).id
    end

    assert_redirected_to photo_bares_path
  end
end
