require 'test/test_helper'

class FleximageTest < Test::Unit::TestCase
  def test_should_be_valid_with_image
    p = PhotoBare.new(:image_file => File.open("#{FIXTURES}/photo.jpg", 'rb'))
    assert p.save, 'Record expected to be allowed to save'
  end
  
  def test_should_require_an_image
    p = PhotoBare.new
    assert !p.save, 'Record expected to not be allowed to save'
    assert_equal 1, p.errors.size
    assert_equal 'is required', p.errors.on(:image_file)
  end
  
  def test_should_require_an_valid_image
    p = PhotoBare.new(:image_file => MockFile.new("#{FIXTURES}/not_a_photo.txt"))
    assert !p.save, 'Record expected to not be allowed to save'
    assert_equal 1, p.errors.size
    assert_equal 'was not a readable image', p.errors.on(:image_file)
  end
end
