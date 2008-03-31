module Fleximage
  class View
    class TemplateDidNotReturnImage < RuntimeError #:nodoc:
    end
    
    def initialize(view)
      @view = view
    end
    
    def render(template, local_assigns = {})
      # process the view
      result = @view.instance_eval do
        
        # inject assigns into instance variables
        assigns.each do |key, value|
          instance_variable_set "@#{key}", value
          value.load_image if value.respond_to?(:load_image)
        end
        
        # inject local assigns into reader methods
        local_assigns.each do |key, value|
          class << self; self; end.send(:define_method, key) { val }
        end
        
        #execute the template
        eval(template)
      end
      
      # Raise an error if object returned from template is not an image record
      unless result.class.include?(Fleximage::Model)
        raise TemplateDidNotReturnImage, ".flexi template was expected to return a model instance that includes Fleximage::Model, but got an instance of <#{result.class}> instead."
      end
      
      # get rendered result
      rendered_image = result.output_image
      
      # Set proper content type
      @view.controller.headers["Content-Type"] = 'image/jpeg'
      
      # Return image data
      rendered_image
    ensure
    
      # ensure garbage collection happens after every flex image render
      GC.start
    end
  end
end