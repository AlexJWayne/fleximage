desc "Explaining what the task does"
namespace :fleximage do  
  namespace :convert do
    
    desc "Convert a flat images/123.png style image store to a images/2007/11/12/123.png style.  Requires FLEXIMAGE_CLASS=ModelName"
    task :to_nested => :environment do
      model_class = ENV['FLEXIMAGE_CLASS'].camelcase.constantize
      model_class.find(:all).each do |obj|
        creation = obj[:created_at] || obj[:created_on]
        
        old_path = "#{RAILS_ROOT}/#{model_class.image_directory}/#{obj.id}.#{model_class.image_storage_format}"
        new_path = "#{RAILS_ROOT}/#{model_class.image_directory}/#{creation.year}/#{creation.month}/#{creation.day}/#{obj.id}.#{model_class.image_storage_format}"
        
        if old_path != new_path && File.exists?(old_path)
          FileUtils.mkdir_p(File.dirname(new_path))
          FileUtils.move old_path, new_path
          puts "#{old_path} -> #{new_path}"
        end
      end
    end
    
    desc "Convert a nested images/2007/11/12/123.png style image store to a images/123.png style.  Requires FLEXIMAGE_CLASS=ModelName"
    task :to_flat => :environment do
      model_class = ENV['FLEXIMAGE_CLASS'].camelcase.constantize
      model_class.find(:all).each do |obj|
        creation = obj[:created_at] || obj[:created_on]
        old_path = "#{RAILS_ROOT}/#{model_class.image_directory}/#{creation.year}/#{creation.month}/#{creation.day}/#{obj.id}.#{model_class.image_storage_format}"
        new_path = "#{RAILS_ROOT}/#{model_class.image_directory}/#{obj.id}.#{model_class.image_storage_format}"        
        
        if old_path != new_path && File.exists?(old_path)
          FileUtils.mkdir_p(File.dirname(new_path))
          FileUtils.move old_path, new_path
          puts "#{old_path} -> #{new_path}"
        end
      end
    end
    
    desc "Convert master images stored as JPGs to PNGs"
    task :to_png => :environment do
      model_class = ENV['FLEXIMAGE_CLASS'].camelcase.constantize
      model_class.find(:all).each do |obj|
        old_path = obj.file_path.gsub(/\.png$/, '.jpg')
        new_path = obj.file_path.gsub(/\.jpg$/, '.png')
        if File.exists?(old_path)
          image = Magick::Image.read(old_path).first
          image.format = 'PNG'
          image.write(new_path)
          File.delete(old_path)
          puts "JPG -> PNG : Image #{obj.id}"
        end
      end
    end
    
    desc "Convert master images stored as PNGs to JPGs"
    task :to_jpg => :environment do
      model_class = ENV['FLEXIMAGE_CLASS'].camelcase.constantize
      model_class.find(:all).each do |obj|
        old_path = obj.file_path.gsub(/\.jpg$/, '.png')
        new_path = obj.file_path.gsub(/\.png$/, '.jpg')
        if File.exists?(old_path)
          image = Magick::Image.read(old_path).first
          image.format = 'JPG'
          image.write(new_path)
          File.delete(old_path)
          puts "PNG -> JPG : Image #{obj.id}"
        end
      end
    end
    
  end
end
