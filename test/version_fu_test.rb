require File.join(File.dirname(__FILE__), 'test_helper')

class Page < ActiveRecord::Base
  version_fu
end

class VersionFuTest < Test::Unit::TestCase
  fixtures :pages, :page_versions
  
  def test_true
    assert true
  end
end