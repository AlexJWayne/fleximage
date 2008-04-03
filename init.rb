require 'open-uri'

# Load RMagick
begin
  require 'RMagick'
rescue MissingSourceFile => e
  puts %{ERROR :: FlexImage requires the RMagick gem.  http://rmagick.rubyforge.org/install-faq.html}
  raise e
end

# Load dsl_accessor
begin
  require 'dsl_accessor'
rescue MissingSourceFile => e
  puts %{ERROR :: FlexImage requires the dsl_accessor gem.  "gem install dsl_accessor"}
  raise e
end

# Load Operators
require 'fleximage/operator/base'
Dir.entries("#{File.dirname(__FILE__)}/lib/fleximage/operator").each do |filename|
  require "fleximage/operator/#{filename.gsub('.rb', '')}" if filename =~ /\.rb$/
end

# Setup Model
require 'fleximage/model'
ActiveRecord::Base.class_eval { include Fleximage::Model }

# Image Proxy
require 'fleximage/image_proxy'

# Setup View
require 'fleximage/view'
ActionController::Base.exempt_from_layout :flexi
ActionView::Base.register_template_handler :flexi, Fleximage::View

# Register mime types
Mime::Type.register "image/jpeg", :jpg
Mime::Type.register "image/gif", :gif
Mime::Type.register "image/png", :png