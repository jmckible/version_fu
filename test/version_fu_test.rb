require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'fixtures/author')
require File.join(File.dirname(__FILE__), 'fixtures/page')

class VersionFuTest < Test::Unit::TestCase
  fixtures :pages, :page_versions, :authors
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
  
  #############################################################################
  #                                   C R E A T E                             #
  #############################################################################
  def test_should_save_version_on_create
    old_count = Page.count
    old_version_count = Page::Version.count
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    assert_equal old_count + 1, Page.count
    assert_equal old_version_count + 1, Page::Version.count
  end
  
  def test_wire_up_association_on_create
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    assert_equal Page::Version.find(:first, :order=>'id desc'), page.versions.first
  end
  
  def test_begin_version_numbering_at_one
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    assert_equal 1, page.version
    assert_equal 1, page.versions.first.version
  end
  
  def test_assigns_attributes_on_create
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    version = page.versions.first
    assert_equal 'New', version.title
    assert_equal 'body', version.body
    assert_equal authors(:larry).id, version.author_id
  end
  
end