module Fleximage
  
  module AviaryController
    
    def self.api_key(value = nil)
      @@api_key ||= nil
      @@api_key = value if value
    end
    
    def self.api_key=(value = nil)
      api_key value
    end
    
    # Include acts_as_fleximage class method
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      # Invoke this method to enable this controller to allow editing of images via Aviary
      def editable_in_aviary(model_class)
        # Don't verify authenticity for aviary callback
        protect_from_forgery :except => :aviary_image_update 
        
        # Include the necesary instance methods
        include Fleximage::AviaryController::InstanceMethods
        
        # Save the Fleximage model class
        model_class = model_class.constantize if model_class.is_a?(String)
        dsl_accessor :aviary_model_class, :default => model_class
      end
      
    end
    
    module InstanceMethods
      
      # Deliver the master image to aviary
      def aviary_image
        model_class = self.class.aviary_model_class
        @model = model_class.find(params[:id])
        render :text => @model.load_image.to_blob, :content_type => Mime::Type.lookup_by_extension(model_class.image_storage_format.to_s)
      end
      
      # Aviary posts the edited image back to the controller here
      def aviary_image_update
        @model = self.class.aviary_model_class.find(params[:id])
        @model.image_file_url = params[:imageurl]
        @model.save
        render :text => 'Image Updated From Aviary'
      end
      
    end
  end
  
end