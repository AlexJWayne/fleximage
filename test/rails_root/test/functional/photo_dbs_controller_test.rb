require File.dirname(__FILE__) + '/../test_helper'

class PhotoDbsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_dbs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_photo_db
    assert_difference('PhotoDb.count') do
      post :create, :photo_db => { }
    end

    assert_redirected_to photo_db_path(assigns(:photo_db))
  end

  def test_should_show_photo_db
    get :show, :id => photo_dbs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => photo_dbs(:one).id
    assert_response :success
  end

  def test_should_update_photo_db
    put :update, :id => photo_dbs(:one).id, :photo_db => { }
    assert_redirected_to photo_db_path(assigns(:photo_db))
  end

  def test_should_destroy_photo_db
    assert_difference('PhotoDb.count', -1) do
      delete :destroy, :id => photo_dbs(:one).id
    end

    assert_redirected_to photo_dbs_path
  end
end
