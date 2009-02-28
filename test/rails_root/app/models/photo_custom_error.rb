class PhotoCustomError < ActiveRecord::Base
  set_table_name :photo_dbs
  acts_as_fleximage :image_directory => 'public/uploads'
end
