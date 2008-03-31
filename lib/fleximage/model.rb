module Fleximage
  module Model
    
    # Include acts_as_fleximage class method
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def acts_as_fleximage(options = {})
        unless options[:image_directory]
          raise "No place to put images!  Declare this via the :image_directory => 'path/to/directory' relative to RAILS_ROOT"
        end
        
        class_eval <<-CLASS_CODE
          include Fleximage::Model::InstanceMethods
          
          dsl_accessor :image_directory, :default => "#{options[:image_directory]}"
          
          before_destroy :delete_image_file
          after_save :save_image_file
        CLASS_CODE
      end
    end
    
    module InstanceMethods
      
      # Returns the path to the master image file for this record.
      #   
      #   @some_image
      def file_path
        "#{RAILS_ROOT}/#{self.class.image_directory}/#{id}.png"
      end
      
      def image_file=(file)
        if file.respond_to?(:read) && file.size > 0
          
          # Create RMagick Image object from uploaded file
          if file.path
            @uploaded_image = Magick::Image.read(file.path).first
          else
            @uploaded_image = Magick::Image.from_blob(file.read).first
          end
          
          # Convert to a lossless format for saving the master image
          @uploaded_image.format = 'PNG'
        else
          raise "No file!"
        end
      end
      
      def load_image
        @output_image ||= Magick::Image.read(file_path).first
      end
      
      def output_image
        @output_image.format = 'JPG'
        @output_image.to_blob
      end
      
      private
        # Write this image to disk
        def save_image_file
          if @uploaded_image
            @uploaded_image.write(file_path)
            GC.start
          end
        end
        
        # Delete the image file after this record gets destroyed
        def delete_image_file
          File.delete(file_path)
        end
    end
    
  end
end