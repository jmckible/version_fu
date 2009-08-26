require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

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