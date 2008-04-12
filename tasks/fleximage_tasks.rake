namespace :fleximage do
  namespace :convert do
    
    # Find the model class
    def model_class
      raise 'You must specify a FLEXIMAGE_CLASS=MyClass' unless ENV['FLEXIMAGE_CLASS']
      @model_class ||= ENV['FLEXIMAGE_CLASS'].camelcase.constantize
    end
    
    def convert_directory_format(to_format)
      model_class.find(:all).each do |obj|
        
        # Get the creation date
        creation = obj[:created_at] || obj[:created_on]
        
        # Generate both types of file paths
        flat_path   = "#{RAILS_ROOT}/#{model_class.image_directory}/#{obj.id}.#{model_class.image_storage_format}"
        nested_path = "#{RAILS_ROOT}/#{model_class.image_directory}/#{creation.year}/#{creation.month}/#{creation.day}/#{obj.id}.#{model_class.image_storage_format}" 
        
        # Assign old path and new path based on desired directory format
        if to_format == :nested
          old_path = flat_path
          new_path = nested_path
        else
          old_path = nested_path
          new_path = flat_path
        end
        
        # Move the files
        if old_path != new_path && File.exists?(old_path)
          FileUtils.mkdir_p(File.dirname(new_path))
          FileUtils.move old_path, new_path
          puts "#{old_path} -> #{new_path}"
        end
      end
    end
    
    def convert_image_format(to_format)
      model_class.find(:all).each do |obj|
        
        # Generate both types of file paths
        png_path = obj.file_path.gsub(/\.jpg$/, '.png')
        jpg_path = obj.file_path.gsub(/\.png$/, '.jpg')
        
        # Output stub
        output = (to_format == :jpg) ? 'PNG -> JPG' : 'JPG -> PNG'
        
        # Assign old path and new path based on desired image format
        if to_format == :jpg
          old_path = png_path
          new_path = jpg_path
        else
          old_path = jpg_path
          new_path = png_path
        end
        
        # Perform conversion
        if File.exists?(old_path)
          image = Magick::Image.read(old_path).first
          image.format = to_format.to_s.upcase
          image.write(new_path)
          File.delete(old_path)
          
          puts "#{output} : Image #{obj.id}"
        end
      end
    end
    
    desc "Convert a flat images/123.png style image store to a images/2007/11/12/123.png style.  Requires FLEXIMAGE_CLASS=ModelName"
    task :to_nested => :environment do
      convert_directory_format :nested
    end
    
    desc "Convert a nested images/2007/11/12/123.png style image store to a images/123.png style.  Requires FLEXIMAGE_CLASS=ModelName"
    task :to_flat => :environment do
      convert_directory_format :flat
    end
    
    desc "Convert master images stored as JPGs to PNGs"
    task :to_png => :environment do
      convert_image_format :png
    end
    
    desc "Convert master images stored as PNGs to JPGs"
    task :to_jpg => :environment do
      convert_image_format :jpg
    end
    
  end
end
