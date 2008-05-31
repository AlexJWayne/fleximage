require File.dirname(__FILE__) + '/../../test/test_helper'

class PhotoDbDefault < ActiveRecord::Base
  set_table_name :photo_dbs
  
  acts_as_fleximage do
    require_image false
    default_image :size => '320x240', :color => 'red'
  end
  
end

class FleximageDefaultImageOptionTest < Test::Unit::TestCase
  
  def test_should_generate_a_default_image
    p = PhotoDbDefault.new
    assert p.save
    assert_equal 320, p.load_image.columns
    assert_equal 240, p.load_image.rows
    assert_color [255, 0, 0], '160x120', p
  end
  
end