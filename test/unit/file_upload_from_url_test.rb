require 'test/test_helper'

class FleximageFileUploadFromUrlTest < Test::Unit::TestCase
  def test_should_be_valid_with_image_from_url
    p = PhotoBare.new(:image_file_url => files(:web_photo))
    assert p.save, 'Record expected to be valid after upload via URL'
  end
  
  def test_should_be_invalid_with_nonimage_from_url
    p = PhotoBare.new(:image_file_url => 'http://www.google.com/')
    assert !p.save, 'Record expected to be invalid after upload via URL'
    assert_equal 1, p.errors.size
    assert_equal 'was not a readable image', p.errors.on(:image_file_url)
  end
  
  def test_should_be_invalid_with_invalid_url
    p = PhotoBare.new(:image_file_url => 'foo')
    assert !p.save, 'Record expected to be invalid after upload via URL'
    assert_equal 1, p.errors.size
    assert_equal 'was not a readable image', p.errors.on(:image_file_url)
  end
end
