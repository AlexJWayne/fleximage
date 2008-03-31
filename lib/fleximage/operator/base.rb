module Fleximage
  module Operator
    
    # The Operator::Base class is what all other Operator classes inherit from.
    # To write your own Operator class, simply inherit from this class, and 
    # implement your own operate methods, with your own arguments.  Just 
    # return a new RMagick image object that represents the new image, and
    # the model will be updated automatically.
    #
    # You have access to a few instance variable in the operate method:
    #
    #  * @image : The current image from the model.  Use this is a starting 
    #    point for all transformations.
    #  * @model_object : The model object that this image belongs to.  Use
    #    its values to determine 
    class Base
      # Create a operator, capturing the model object to operate on
      def initialize(model_object)
        @model_object = model_object
      end
      
      # Start the operation
      def execute(*args)
        @image = @model_object.load_image
        operate(*args)
      end
      
      private
        # Perform the operation
        def operate(*args)
          raise "Override this method in your own subclass."
        end
      
      
        # ---
        # - Support methods
        # ---
        
        def size_to_xy(size)
          if size.is_a?(Array) && size.size == 2
            size
          elsif size.to_s.include?('x')
            size.split('x').collect(&:to_i)
          else
            [size.to_i, size.to_i]
          end
        end
        
        def scale(size, img = nil)
          (img || @image).change_geometry!(size_to_xy(size).join('x')) do |cols, rows, img|
            cols = 1 if cols < 1
            rows = 1 if rows < 1
            img.resize!(cols, rows)
          end
        end

        def scale_and_crop(size, img = nil)
          (img || @image).crop_resized!(*size_to_xy(size))
        end

        def stretch(size, img = nil)
          (img || @image).resize!(*size_to_xy(size))
        end

        def symbol_to_blending_mode(mode)
          "Magick::#{mode.to_s.camelize}CompositeOp".constantize
        rescue NameError
          raise ArgumentError, ":#{mode} is not a valid blending mode."
        end
        
        
    end # Base
    
    GRAVITIES = {
      :center       => Magick::CenterGravity,
      :top          => Magick::NorthGravity,
      :top_right    => Magick::NorthEastGravity,
      :right        => Magick::EastGravity,
      :bottom_right => Magick::SouthEastGravity,
      :bottom       => Magick::SouthGravity,
      :bottom_left  => Magick::SouthWestGravity,
      :left         => Magick::WestGravity,
      :top_left     => Magick::NorthWestGravity,
    } unless defined?(GRAVITIES)
    
  end # Operator
end # Fleximage