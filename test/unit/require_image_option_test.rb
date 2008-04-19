require 'test/test_helper'

class FleximageTest < Test::Unit::TestCase
  def test_should_require_image_by_default
    p = PhotoBare.new
    assert !p.save, 'Record expected to not be allowed to save'
  end
  
  def test_should_disable_image_requirement
    PhotoBare.require_image = false
    p = PhotoBare.new
    assert p.save, 'Record expected to be allowed to save'
  ensure
    PhotoBare.require_image = true
  end
end