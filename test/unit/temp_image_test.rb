require File.dirname(__FILE__) + '/../../test/test_helper'

class FleximageTempImageTest < Test::Unit::TestCase
  def test_should_save_and_use_a_temp_image
    a1 = Avatar.new(:image_file => files(:photo))
    assert !a1.save
    assert_match /^\d+_\d+$/, a1.image_file_temp
    assert File.exists?("#{RAILS_ROOT}/tmp/fleximage/#{a1.image_file_temp}")
    temp_file_path = a1.image_file_temp
    
    a2 = Avatar.new(:username => 'Alex Wayne', :image_file_temp => temp_file_path)
    
    assert a2.save
    assert File.exists?(a2.file_path)
    assert !File.exists?("#{RAILS_ROOT}/tmp/fleximage/#{temp_file_path}")
  end
  
  def test_should_prevent_directory_traversal_attacks
    a1 = Avatar.new(:image_file_temp => '../fleximage/photo.jpg')
    assert !a1.save
    assert_equal nil, a1.image_file_temp
  end
end
