require 'test/test_helper'

PHOTO_PATH = 'test/fixtures/photo.jpg';

class FleximageTest < Test::Unit::TestCase
  def test_should_be_valid_with_image
    p = PhotoBare.new(:image_file => MockFile.new(PHOTO_PATH))
    assert p.save, 'Record expected to be allowed to save'
  end
  
  def test_should_require_an_image
    p = PhotoBare.new
    assert !p.save, 'Record expected to not be allowed to save'
  end
  
  def test_should_disable_image_requirement
    PhotoBare.require_image = false;
    p = PhotoBare.new
    assert p.save, 'Record expected to be allowed to save'
  ensure
    PhotoBare.require_image = true;
  end
  
  def test_image_should_create_from_url
    p = PhotoBare.new(:image_file_url => 'http://www.google.com/intl/en_ALL/images/logo.gif')
    assert p.save, "Record expected to be allowed to save after upload via URL"
  end
end
