module Fleximage
  
  # Container for Fleximage model method inclusion modules
  module Model
    
    class MasterImageNotFound < RuntimeError #:nodoc:
    end
    
    # Include acts_as_fleximage class method
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end
    
    # Provides class methods for Fleximage for use in model classes.  The only class method is
    # acts_as_fleximage which integrates Fleximage functionality into a model class.
    #
    # The following class level accessors also get inserted.
    #
    # * +image_directory+: (String, no default) Where the master images are stored, directory path relative to your 
    #   app root.
    # * +use_creation_date_based_directories+: (Boolean, default +true+) If true, master images will be stored in
    #   directories based on creation date.  For example: <tt>"#{image_directory}/2007/11/24/123.png"</tt> for an
    #   image with an id of 123 and a creation date of November 24, 2007.  Turing this off would cause the path
    #   to be "#{image_directory}/123.png" instead.  This helps keep the OS from having directories that are too 
    #   full.
    # * +image_storage_format+: (:png or :jpg, default :png) The format of your master images.  Using :png will give 
    #   you the best quality, since the master images as stored as lossless version of the original upload.  :jpg 
    #   will apply lossy compression, but the master image file sizes will be much smaller.  If storage space is a 
    #   concern, us :jpg.
    # * +require_image+: (Boolean, default +true+) The model will raise a validation error if no image is uploaded
    #   with the record.  Setting to false allows record to be saved with no images.
    # * +missing_image_message+: (String, default "is required") Validation message to display when no image was uploaded for 
    #   a record.
    # * +invalid_image_message+: (String default "was not a readable image") Validation message when an image is uploaded, but is not an 
    #   image format that can be read by RMagick.
    # * +output_image_jpg_quality+: (Integer, default 85) When rendering JPGs, this represents the amount of
    #   compression.  Valid values are 0-100, where 0 is very small and very ugly, and 100 is near lossless but
    #   very large in filesize.
    # * +preprocess_image+: (Block, no default) Call this class method just like you would call +operate+ in a view.
    #   The image transoformation in the provided block will be run on every uploaded image before its saved as the 
    #   master image.
    #
    # Example:
    #
    #   class Photo < ActiveRecord::Base
    #     acts_as_fleximage :image_directory => 'public/images/uploaded'
    #     use_creation_date_based_directories true
    #     image_storage_format :png
    #     require_image true
    #     missing_image_message 'is required'
    #     invalid_image_message 'was not a readable image'
    #     output_image_jpg_quality 85
    #   
    #     preprocess_image do |image|
    #       image.resize '1024x768'
    #     end
    #   
    #     # normal model methods...
    #   end
    module ClassMethods
      
      # Use this method to include Fleximage functionality in your model.  It takes an 
      # options hash with a single required key, :+image_directory+.  This key should 
      # point to the directory you want your images stored on your server.
      def acts_as_fleximage(options = {})
        # Require the declaration of a master image storage directory
        unless options[:image_directory]
          raise "No place to put images!  Declare this via the :image_directory => 'path/to/directory' option (relative to RAILS_ROOT)"
        end
        
        # Insert methods
        class_eval do
          include Fleximage::Model::InstanceMethods
          
          # Call this class method just like you would call +operate+ in a view.
          # The image transoformation in the provided block will be run on every uploaded image before its saved as the 
          # master image.
          def self.preprocess_image(&block)
            preprocess_image_operation(block)
          end
        end
        
        # Where images get stored
        dsl_accessor :image_directory
        
        # Put uploads from different days into different subdirectories
        dsl_accessor :use_creation_date_based_directories, :default => true
        
        # The format are master images are stored in
        dsl_accessor :image_storage_format, :default => Proc.new { :png }
        
        # Require a valid image.  Defaults to true.  Set to false if its ok to have no image for
        dsl_accessor :require_image, :default => true
        
        # Missing image message
        dsl_accessor :missing_image_message, :default => 'is required'
        
        # Invalid image message
        dsl_accessor :invalid_image_message, :default => 'was not a readable image'
        
        # Sets the quality of rendered JPGs
        dsl_accessor :output_image_jpg_quality, :default => 85
        
        # A block that processes an image before it gets saved as the master image of a record.
        # Can be helpful to resize potentially huge images to something more manageable. Set via
        # the "preprocess_image { |image| ... }" class method.
        dsl_accessor :preprocess_image_operation
        
        # Image related save and destroy callbacks
        after_destroy :delete_image_file
        after_save    :save_image_file
        
        image_directory options[:image_directory]
      end
    end
    
    # Provides methods that every model instance that acts_as_fleximage needs.
    module InstanceMethods
      
      # Returns the path to the master image file for this record.
      #   
      #   @some_image.directory_path #=> /var/www/myapp/uploaded_images
      #
      # If this model has a created_at field, it will use a directory 
      # structure based on the creation date, to prevent hitting the OS imposed
      # limit on the number files in a directory.
      #
      #   @some_image.directory_path #=> /var/www/myapp/uploaded_images/2008/3/30
      def directory_path
        # base directory
        directory = "#{RAILS_ROOT}/#{self.class.image_directory}"
        
        # specific creation date based directory suffix.
        creation = self[:created_at] || self[:created_on]
        if self.class.use_creation_date_based_directories && creation 
          "#{directory}/#{creation.year}/#{creation.month}/#{creation.day}"
        else
          directory
        end
      end
      
      # Returns the path to the master image file for this record.
      #   
      #   @some_image.file_path #=> /var/www/myapp/uploaded_images/123.png
      def file_path
        "#{directory_path}/#{id}.#{self.class.image_storage_format}"
      end
      
      # Sets the image file for this record to an uploaded file.  This can 
      # be called directly, or passively like from an ActiveRecord mass 
      # assignment.
      # 
      # Rails will automatically call this method for you, in most of the 
      # situations you would expect it to.
      #
      #   # via mass assignment, the most common form you'll probably use
      #   Photo.new(params[:photo])
      #   Photo.create(params[:photo])
      #
      #   # via explicit assignment hash
      #   Photo.new(:image_file => params[:photo][:image_file])
      #   Photo.create(:image_file => params[:photo][:image_file])
      #   
      #   # Direct Assignment, usually not needed
      #   photo = Photo.new
      #   photo.image_file = params[:photo][:image_file]
      #   
      #   # via an association proxy
      #   p = Product.find(1)
      #   p.images.create(params[:photo])
      def image_file=(file)
        # Get the size of the file.  file.size works for form-uploaded images, file.stat.size works
        # for file object created by File.open('foo.jpg', 'rb')
        file_size = file.respond_to?(:size) ? file.size : file.stat.size
        
        if file.respond_to?(:read) && file_size > 0
          # Create RMagick Image object from uploaded file
          if file.path
            @uploaded_image = Magick::Image.read(file.path).first
          else
            @uploaded_image = Magick::Image.from_blob(file.read).first
          end
                    
          # Success, make sure everything is valid
          @missing_image = false
          @invalid_image = false
        else
          if self.class.require_image && !@uploaded_image
            @missing_image = true
          end
        end
      rescue Magick::ImageMagickError => e
        if e.to_s =~ /no decode delegate for this image format/
          @invalid_image = true
        else
          raise e
        end
      end
      
      # Assign the image via a URL, which will make the plugin go
      # and fetch the image at the provided URL.  The image will be stored
      # locally as a master image for that record from then on.  This is 
      # intended to be used along side the image upload to allow people the
      # choice to upload from their local machine, or pull from the internet.
      #
      #   @photo.image_file_url = 'http://foo.com/bar.jpg'
      def image_file_url=(file_url)
        @image_file_url = file_url
        if file_url =~ %r{^https?://}
          self.image_file = open(file_url)
        elsif file_url.empty?
          @missing_image = true unless @uploaded_image
        else
          @invalid_image = true
        end
      end
      
      # Return the @image_file_url that was previously assigned.  This is not saved
      # in the database, and only exists to make forms happy.
      def image_file_url
        @image_file_url
      end
      
      # Return true if this record has an image.
      def has_image?
        File.exists?(file_path)
      end
      
      # Call from a .flexi view template.  This enables the rendering of operators 
      # so that you can transform your image.  This is the method that is the foundation
      # of .flexi views.  Every view should consist of image manipulation code inside a
      # block passed to this method. 
      #
      #   # app/views/photos/thumb.jpg.flexi
      #   @photo.operate do |image|
      #     image.resize '320x240'
      #   end
      def operate(&block)
        returning self do
          @operating = true
          block.call(self)
          @operating = false
        end
      end
      
      # Load the image from disk, or return the cached and potentially 
      # processed output rmagick image.
      def load_image #:nodoc:
        @output_image ||= @uploaded_image || Magick::Image.read(file_path).first
        
      rescue Magick::ImageMagickError => e
        if e.to_s =~ /unable to open file/
          raise MasterImageNotFound, 
            "Master image was not found for this record, so no image can be rendered.\n"+
            "Expected image to be at:\n"+
            "  #{file_path}"
        else
          raise e
        end
      end
      
      # Convert the current output image to a jpg, and return it in binary form.  options support a
      # :format key that can be :jpg, :gif or :png
      def output_image(options = {}) #:nodoc:
        format = (options[:format] || :jpg).to_s.upcase
        @output_image.format = format
        @output_image.strip!
        if format = 'JPG'
          quality = self.class.output_image_jpg_quality
          @output_image.to_blob { self.quality = quality }
        else
          @output_image.to_blob
        end
      ensure
        GC.start
      end
      
      # If in a view, a call to an unknown method will look for an Operator by that method's name.
      # If it find one, it will execute that operator, otherwise it will simply call super for the
      # default method missing behavior.
      def method_missing(method_name, *args)
        if @operating
          operator_class = "Fleximage::Operator::#{method_name.to_s.camelcase}".constantize
          @output_image = operator_class.new(self).execute(*args)
        else
          super
        end
      rescue NameError => e
        if e.to_s =~ /uninitialized constant Fleximage::Operator::/
          super
        else
          raise e
        end
      end
      
      # Delete the image file for this record. This is automatically ran after this record gets 
      # destroyed, but you can call it manually if you want to remove the image from the record.
      def delete_image_file
        File.delete(file_path) if File.exists?(file_path)
      end
      
      # Execute image presence and validity validations.
      def validate #:nodoc:
        field_name = (@image_file_url && @image_file_url.any?) ? :image_file_url : :image_file
          
        if self.class.require_image && @missing_image && !has_image?
          errors.add field_name, self.class.missing_image_message
        elsif @invalid_image
          errors.add field_name, self.class.invalid_image_message
        end
      end
      
      private
        # Write this image to disk
        def save_image_file
          if @uploaded_image
            # perform preprocessing
            perform_preprocess_operation
            
            # Convert to storage format
            @uploaded_image.format = self.class.image_storage_format.to_s.upcase
            
            # Make sure target directory exists
            FileUtils.mkdir_p(directory_path)
            
            # Write master image file
            @uploaded_image.write(file_path)
            
            # Start GC to close up memory leaks
            GC.start
          end
        end
        
        # Preprocess this image before saving
        def perform_preprocess_operation
          if self.class.preprocess_image_operation
            operate(&self.class.preprocess_image_operation)
            @uploaded_image = @output_image
          end
        end
    end
    
  end
end