class PhotoS3 < ActiveRecord::Base
  acts_as_fleximage do
    s3_bucket 'test-bucket'
  end
end
