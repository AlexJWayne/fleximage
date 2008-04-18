require 'test/test_helper'

class FleximageTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_should_require_image
    p = PhotoBare.new
    assert !p.save, 'Photo with no image was saved!'
  end
end
