require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'

desc 'Default: run unit tests.'
task :default=>:test

desc 'Test the version_fu plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.libs << 'test/models'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "nbudin-version_fu"
    gemspec.summary = "Gemified version of the version_fu plugin, tracking changes from revo and jmckible."
    gemspec.description = "version_fu is a ActveRecord versioning gem that takes advantage of the new dirty attribute checking available in Rails 2.1. Previous solutions like Rick Olson's acts_as_versioned are no long compatible with Rails."
    gemspec.email = ""
    gemspec.homepage = ""
    gemspec.description = "TODO"
    gemspec.authors = ["Jordan McKible"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
