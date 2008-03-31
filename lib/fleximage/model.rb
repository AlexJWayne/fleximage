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
      #   @some_image.file_path #=> /var/www/myapp/uploaded_images
      def file_path
        "#{RAILS_ROOT}/#{self.class.image_directory}/#{id}.png"
      end
      
      # Sets the image file for this record to an uploaded file.  This can 
      # be called directly, or passively like from an ActiveRecord mass 
      # assignment.
      # 
      # Rails will automatically call this method for you, in most of the 
      # situations you would expect it to.
      #
      #   # Direct Assignment, usually not needed
      #   photo = Photo.new
      #   photo.image_file = params[:photo][:image_file]
      #   
      #   # via explicit assignment hash
      #   Photo.new(:image_file => params[:photo][:image_file])
      #   Photo.create(:image_file => params[:photo][:image_file])
      #   
      #   # via mass assignment from, the most common form you'll probably use
      #   Photo.new(params[:photo])
      #   Photo.create(params[:photo])
      #   
      #   # via an association proxy
      #   p = Product.find(1)
      #   p.images.create(params[:photo])
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
      
      # Load the image from disk, or return the cached and potentially 
      # processed output rmagick image.
      def load_image #:nodoc:
        @output_image ||= Magick::Image.read(file_path).first
      end
      
      # Convert the current output image to a jpg, and return it in 
      # binary form.
      def output_image #:nodoc:
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