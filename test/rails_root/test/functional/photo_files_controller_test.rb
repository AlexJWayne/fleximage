require File.dirname(__FILE__) + '/../test_helper'

class PhotoFilesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_files)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_photo_file
    assert_difference('PhotoFile.count') do
      post :create, :photo_file => { }
    end

    assert_redirected_to photo_file_path(assigns(:photo_file))
  end

  def test_should_show_photo_file
    get :show, :id => photo_files(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => photo_files(:one).id
    assert_response :success
  end

  def test_should_update_photo_file
    put :update, :id => photo_files(:one).id, :photo_file => { }
    assert_redirected_to photo_file_path(assigns(:photo_file))
  end

  def test_should_destroy_photo_file
    assert_difference('PhotoFile.count', -1) do
      delete :destroy, :id => photo_files(:one).id
    end

    assert_redirected_to photo_files_path
  end
end
