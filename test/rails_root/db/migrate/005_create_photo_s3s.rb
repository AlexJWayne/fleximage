class CreatePhotoS3s < ActiveRecord::Migration
  def self.up
    create_table :photo_s3s do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :photo_s3s
  end
end
