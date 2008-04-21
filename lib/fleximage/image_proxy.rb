module Fleximage
  
  # An instance of this class is yielded when Model#operate is called.  It enables image operators
  # to be called to transform the image.  You should never need to directly deal with this class.
  # You simply call image operators on this object when inside an Model#operate block
  #
  #   @photo.operate do |image|
  #     image.resize '640x480'
  #   end
  #
  # In this example, +image+ is an instance of ImageProxy
  class ImageProxy
    
    class OepratorNotFound < NameError #:nodoc:
    end
    
    # The image to be manipulated by operators.
    attr_accessor :image
    
    # Create a new image operator proxy.
    def initialize(image, model_obj)
      @image = image
      @model = model_obj
    end
    
    # A call to an unknown method will look for an Operator by that method's name.
    # If it finds one, it will execute that operator.
    def method_missing(method_name, *args)
      # Find the operator class
      class_name = method_name.to_s.camelcase
      operator_class = "Fleximage::Operator::#{class_name}".constantize
      
      # Execute the operator
      @image = operator_class.new(self, @image, @model).execute(*args)
    
    rescue NameError => e
      if e.to_s =~ /uninitialized constant Fleximage::Operator::#{class_name}/
        raise OepratorNotFound, "No operator Fleximage::Operator::#{class_name} found for the method \"#{method_name}\""
      else
        raise e
      end
    end
  end
  
end