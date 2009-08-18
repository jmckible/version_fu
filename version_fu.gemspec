# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{version_fu}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jordan McKible"]
  s.date = %q{2009-08-13}
  s.description = %q{version_fu is a ActveRecord versioning gem that takes advantage of the new dirty attribute checking available in Rails 2.1. Previous solutions like Rick Olson's acts_as_versioned are no long compatible with Rails.}
  s.email = %q{}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
     "MIT-LICENSE",
     "README.rdoc",
     "RUNNING_UNIT_TESTS",
     "Rakefile",
     "VERSION",
     "lib/version_fu.rb",
     "lib/version_fu/version_fu.rb",
     "test/database.yml",
     "test/fixtures/author.rb",
     "test/fixtures/author_versions.yml",
     "test/fixtures/authors.yml",
     "test/fixtures/page.rb",
     "test/fixtures/page_versions.yml",
     "test/fixtures/pages.yml",
     "test/schema.rb",
     "test/test_helper.rb",
     "test/version_fu_test.rb"
  ]
  s.homepage = %q{}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Gemified version of the version_fu plugin.}
  s.test_files = [
    "test/test_helper.rb",
     "test/version_fu_test.rb",
     "test/schema.rb",
     "test/fixtures/author.rb",
     "test/fixtures/page.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
