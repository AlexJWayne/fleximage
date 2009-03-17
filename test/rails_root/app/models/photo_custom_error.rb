class PhotoCustomError < ActiveRecord::Base
  set_table_name :photo_dbs
  acts_as_fleximage do
    image_directory 'public/uploads'
    minimum_image_size [2, 2]
  end
end
