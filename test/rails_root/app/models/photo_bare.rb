class PhotoBare < ActiveRecord::Base
  acts_as_fleximage do
    image_directory 'public/uploads'
    minimum_image_size [2, 2]
  end
end
