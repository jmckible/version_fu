require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'fixtures/page')

class VersionFuTest < Test::Unit::TestCase
  fixtures :pages, :page_versions
  set_fixture_class :page_versions => Page::Version
  
  def test_parent_has_many_version
    assert_equal pages(:welcome).versions, [page_versions(:welcome_1)]
  end
  
  def test_version_belongs_to_parent
    assert_equal page_versions(:welcome_1).page, pages(:welcome)
  end
  
end