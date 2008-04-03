desc "Explaining what the task does"
namespace :fleximage do  
  namespace :convert do
    
    desc "Convert a flat images/123.png style image store to a images/2007/11/12/123.png style.  Requires FLEXIMAGE_CLASS=ModelName"
    task :flat_to_nested => :environment do
      model_class = ENV['FLEXIMAGE_CLASS'].camelcase.constantize
      model_class.find(:all).each do |obj|
        old_path = obj.file_path
        creation = obj[:created_at] || obj[:created_on]
        new_path = "#{RAILS_ROOT}/#{model_class.image_directory}/#{creation.year}/#{creation.month}/#{creation.day}/#{obj.id}.#{model_class.image_storage_format}"
        
        if old_path != new_path && File.exists?(old_path)
          FileUtils.mkdir_p(File.dirname(new_path))
          FileUtils.move old_path, new_path
          puts "Moved Image #{obj.id}"
        end
      end
    end
    
  end
end
