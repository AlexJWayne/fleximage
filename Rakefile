require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the fleximage plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
end


desc 'Generate documentation for the fleximage plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Fleximage'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fleximage"
    gem.summary = <<EOF
Rails plugin for uploading images as resources, with support for resizing, text
stamping, and other special effects.
EOF
    gem.description = <<EOF
Fleximage is a Rails plugin that tries to make image uploading and rendering
super easy.
EOF
    gem.email = "ruby@beautifulpixel.com"
    gem.homepage = "http://github.com/Squeegy/fleximage"
    gem.authors = `git log --pretty=format:"%an"`.split("\n").uniq.sort
    gem.add_dependency "rmagick"
    gem.add_dependency "aws-s3"
    gem.add_development_dependency "rails", "=2.2.2"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available."
  puts "Install it with: gem install jeweler"
end
