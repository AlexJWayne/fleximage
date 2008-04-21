require File.dirname(__FILE__) + '/../../test/test_helper'

class FleximageFileUploadToDbTest < Test::Unit::TestCase
  def test_should_be_valid_with_image
    p = PhotoDb.new(:image_file => files(:photo))
    assert p.save, 'Record expected to be allowed to save'
    
    p = PhotoDb.find(p.id)
    assert_kind_of Magick::Image, p.load_image
    assert p.image_file_data.size > 0
  end
  
  def test_should_require_an_image
    p = PhotoDb.new
    assert !p.save, 'Record expected to not be allowed to save'
    assert_equal 1, p.errors.size
    assert_equal 'is required', p.errors.on(:image_file)
  end
  
  def test_should_require_an_valid_image
    p = PhotoDb.new(:image_file => files(:not_a_photo))
    assert !p.save, 'Record expected to not be allowed to save'
    assert_equal 1, p.errors.size
    assert_equal 'was not a readable image', p.errors.on(:image_file)
  end
end
