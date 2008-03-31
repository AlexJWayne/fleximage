# $:.unshift "#{File.dirname(__FILE__)}/lib"

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

# Setup Model
require 'fleximage/model'
ActiveRecord::Base.class_eval { include Fleximage::Model }

# Setup View
require 'fleximage/view'
ActionController::Base.exempt_from_layout :flexi
ActionView::Base.register_template_handler :flexi, Fleximage::View