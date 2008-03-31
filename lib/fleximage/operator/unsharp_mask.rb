module Fleximage
  module Operator
    
    # Sharpen an image using an unsharp mask filter
    # 
    #   image.unsharp_mask(options = {})
    #
    # Use the following keys in the +options+ hash:
    #
    # Example:
    #
    #   @photo.operate do |image|
    #     image.unsharp_mask
    #   end
    class UnsharpMask < Operator::Base
      def operate(options = {})
        options = options.symbolize_keys if options.respond_to?(:symbolize_keys)
        options = {
          :radius    => 0.0,
          :sigma     => 1.0,
          :amount    => 0.5,
          :threshold => 0.05
        }.merge(options)

        # sharpen image
        @image = @image.unsharp_mask(options[:radius], options[:sigma], options[:amount], options[:threshold])
      end
    end
    
  end
end