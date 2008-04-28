require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'fixtures/page')

class VersionFuTest < Test::Unit::TestCase
  fixtures :pages, :page_versions
  set_fixture_class :page_versions => Page::Version
  
  #############################################################################
  #                         A S S O C I A T I O N S                           #
  #############################################################################           
  def test_parent_has_many_version
    assert_equal pages(:welcome).versions, [page_versions(:welcome_1)]
  end
  
  def test_version_belongs_to_parent
    assert_equal page_versions(:welcome_1).page, pages(:welcome)
  end
  
  #############################################################################
  #                              A T T R I B U T E S                          #
  #############################################################################
  def test_should_version_proper_attributes
    assert_equal ['title', 'body', 'author_id'], Page.new.versioned_attributes
  end
  
end