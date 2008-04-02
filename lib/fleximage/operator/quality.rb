module Fleximage
  module Operator
    
    # Set the output quality of a processed image
    #
    #   image.quality = 70
    class quality < Operator::Base
      def operate(quality)
        @image.quality = quality.to_i
      end
    end
    
  end
end