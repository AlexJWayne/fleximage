require File.dirname(__FILE__) + '/../../test/test_helper'

class FleximageBasicModelTest < Test::Unit::TestCase
  def test_should_have_correct_file_path_with_creation_date_based_storage
    p = PhotoBare.create(:image_file => files(:photo))
    assert_equal "#{RAILS_ROOT}/public/uploads/#{Time.now.year}/#{Time.now.month}/#{Time.now.day}/#{p.id}.png", p.file_path
  end

  def test_should_have_correct_directory_path_with_creation_date_based_storage
    p = PhotoBare.create(:image_file => files(:photo))
    assert_equal "#{RAILS_ROOT}/public/uploads/#{Time.now.year}/#{Time.now.month}/#{Time.now.day}", p.directory_path
  end

  def test_should_have_correct_file_path_without_creation_date_based_storage
    PhotoBare.use_creation_date_based_directories = false
    p = PhotoBare.create(:image_file => files(:photo))
    assert_equal "#{RAILS_ROOT}/public/uploads/#{p.id}.png", p.file_path
  ensure
    PhotoBare.use_creation_date_based_directories = true
  end

  def test_should_have_correct_directory_path_without_creation_date_based_storage
    PhotoBare.use_creation_date_based_directories = false
    p = PhotoBare.create(:image_file => files(:photo))
    assert_equal "#{RAILS_ROOT}/public/uploads", p.directory_path
  ensure
    PhotoBare.use_creation_date_based_directories = true
  end

  def test_should_not_prepend_rails_root_to_absolute_path
    PhotoBare.image_directory = '/tmp'
    PhotoBare.use_creation_date_based_directories = false
    p = PhotoBare.create(:image_file => files(:photo))
    assert_equal '/tmp', p.directory_path
  end

  def test_should_confirm_presence_of_a_store_when_using_s3
    assert PhotoS3.has_store?
  end
end
