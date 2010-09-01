# -*- encoding: utf-8 -*-


Gem::Specification.new do |s|
  s.name = %q{version_fu}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jordan McKible"]
  s.date = %q{2010-09-01}
  s.description = %q{version_fu helps version your ActiveRecord models. It is based on Rick Olson's acts_as_versioned and is compatible with Rails 3.}
  s.email = %q{}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
     "init.rb",
     "MIT-LICENSE",
     "Rakefile",
     "README.rdoc",
     "VERSION",
     "lib/version_fu.rb",
     "lib/version_fu/version_fu.rb",
  ]
  s.homepage = %q{}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Gemified version of the version_fu plugin.}
  s.test_files = [
     "test/db/database.yml",
     "test/db/schema.rb",
     "test/fixtures/author_versions.yml",
     "test/fixtures/authors.yml",
     "test/fixtures/page_versions.yml",
     "test/fixtures/pages.yml",
     "test/models/author.rb",
     "test/models/page.rb",
     "test/test_helper.rb",
     "test/version_fu_test.rb"
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
