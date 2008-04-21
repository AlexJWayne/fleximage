# Load the environment
ENV['RAILS_ENV'] ||= 'test'
require File.dirname(__FILE__) + '/rails_root/config/environment.rb'
 
# Load the testing framework
require 'test_help'
silence_warnings { RAILS_ENV = ENV['RAILS_ENV'] }
 
# Run the migrations
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")
 
# Setup the fixtures path
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)
 
require File.dirname(__FILE__) + '/mock_file'
require 'open-uri'

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end
 
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  def files(name)
    case name
    when :photo
      MockFile.new("#{RAILS_ROOT}/../fixtures/photo.jpg")
      
    when :not_a_photo
      MockFile.new("#{RAILS_ROOT}/../fixtures/not_a_photo.txt")
    
    when :web_photo
      'http://www.google.com/intl/en_ALL/images/logo.gif'
      
    end
  end
end
