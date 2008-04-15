module Fleximage
  module Helper
    def embedded_image_tag(model_object, options = {})
      model_object.load_image
      format  = options[:format] || :jpg
      mime    = Mime::Type.lookup_by_extension(format.to_s).to_s
      image   = model_object.output_image(:format => format)
      data    = Base64.encode64(image)
      
      options = { :alt => model_object.class.to_s }.merge(options)
      
      result = image_tag("data:#{mime};base64,#{data}", options)
      result.gsub('/images/data:', 'data:')
      
    rescue Fleximage::Model::MasterImageNotFound => e
      nil
    end
  end
end