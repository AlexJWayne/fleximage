module Fleximage
  module Operator
    
    # Crops the image without doing any resizing first.  The operation crops from the :+from+ coordinate,
    # and returns an image of size :+size+ down and right from there.
    # 
    #   image.crop(options = {})
    #
    # Use the following keys in the +options+ hash:
    #
    # * +from+: coorinates for the upper left corner of resulting image.
    # * +size+: The size of the resulting image, going down and to the right of the :+from+ coordinate.
    # 
    # Both options are *required*.
    #
    # Example:
    #
    #   @photo.operate do |image|
    #     image.crop(
    #       :from => '100x50',
    #       :size => '500x350'
    #     )
    #   end
    class Crop < Operator::Base
      def operate(options = {})
        options = options.symbolize_keys

        # required integer keys
        [:from, :size].each do |key|
          raise ArgumentError, ":#{key} must be included in crop options" unless options[key]
          options[key] = size_to_xy(options[key])
        end

        # width and height must not be zero
        options[:size].each do |dimension|
          raise ArgumentError, ":size must not be zero for X or Y" if dimension.zero?
        end

        # crop
        @image.crop!(options[:from][0], options[:from][1], options[:size][0], options[:size][1], true)
      end
    end
    
  end
end