require 'test/test_helper'

class FleximageTest < Test::Unit::TestCase
  def test_should_have_default_storage_format_png
    p = PhotoBare.create(:image_file => MockFile.new("#{FIXTURES}/photo.jpg"))
    assert_match %r{\d+\.png$}, p.file_path
    assert_equal 'PNG', p.load_image.format
  end
  
  def test_should_set_image_storage_format_to_jpg
    PhotoBare.image_storage_format = :jpg
    p = PhotoBare.create(:image_file => MockFile.new("#{FIXTURES}/photo.jpg"))
    assert_match %r{\d+\.jpg$}, p.file_path
    assert_equal 'JPG', p.load_image.format
  ensure
    PhotoBare.image_storage_format = :png
  end
end