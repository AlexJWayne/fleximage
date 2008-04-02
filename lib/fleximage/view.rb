module Fleximage
  
  # Renders a .flexi template
  class View #:nodoc:
    class TemplateDidNotReturnImage < RuntimeError #:nodoc:
    end
    
    def initialize(view)
      @view = view
    end
    
    def render(template, local_assigns = {})
      # process the view
      result = @view.instance_eval do
        
        # Shorthand color creation
        def color(*args)
          if args.size == 1 && args.first.is_a?(String)
            args.first
          else
            Magick::Pixel.new(*args)
          end
        end
        
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
      unless result.class.include?(Fleximage::Model::InstanceMethods)
        raise TemplateDidNotReturnImage, ".flexi template was expected to return a model instance that acts_as_fleximage, but got an instance of <#{result.class}> instead."
      end
      
      # get rendered result
      rendered_image = result.output_image
      
      # Return image data
      return rendered_image
    ensure
    
      # ensure garbage collection happens after every flex image render
      GC.start
    end
  end
end