require 'test_helper'

class VersionFuTest < ActiveSupport::TestCase
  #############################################################################
  #                         A S S O C I A T I O N S                           #
  #############################################################################
  test 'parent has many versions' do
    assert_equal page_versions(:welcome_1, :welcome_2), pages(:welcome).versions 
  end
  
  test 'version belongs to parent' do
    assert_equal pages(:welcome), page_versions(:welcome_1).page
  end
  
  #############################################################################
  #                              A T T R I B U T E S                          #
  #############################################################################
  test 'version proper columns' do
    assert_equal ['title', 'body', 'author_id'], Page.new.versioned_columns
  end
  
  test 'do not version non-existing columns' do
    assert !Page.new.versioned_columns.include?(:creator_id)
  end
  
  #############################################################################
  #                               C R E A T E                                 #
  #############################################################################
  test 'save version on create' do
    old_count = Page.count
    old_version_count = Page::Version.count
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    assert_equal old_count + 1, Page.count
    assert_equal old_version_count + 1, Page::Version.count
  end
  
  test 'wire up associations on create' do
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    assert_equal Page::Version.find(:first, :order=>'id desc'), page.versions.first
  end
  
  test 'begin version numbering at 1' do
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    assert_equal 1, page.version
    assert_equal 1, page.versions.first.version
  end
  
  test 'assign attributes on create' do
    page = Page.create :title=>'New', :body=>'body', :creator=>authors(:larry), :author=>authors(:larry)
    version = page.versions.first
    assert_equal 'New', version.title
    assert_equal 'body', version.body
    assert_equal authors(:larry).id, version.author_id
  end
  
  #############################################################################
  #                                   U P D A T E                             #
  #############################################################################
  test 'save version on update' do
    old_count = Page::Version.count
    page = pages(:welcome)
    page.update_attributes :title=>'New title', :body=>'new body', :author=>authors(:sara)
    assert_equal old_count + 1, Page::Version.count
  end
  
  test 'increment verson number' do
    page = pages(:welcome)
    old_count = page.version
    page.update_attributes :title=>'New title', :body=>'new body', :author=>authors(:sara)
    assert_equal old_count + 1, page.reload.version
  end
  
  test 'update version attributes' do
    page = pages(:welcome)
    page.update_attributes :title=>'Latest', :body=>'newest', :author=>authors(:peter)
    version = page.reload.versions.latest
    assert_equal 'Latest', version.title
    assert_equal 'newest', version.body
    assert_equal authors(:peter).id, version.author_id
  end
  
  #############################################################################
  #                         S K I P    V E R S I O N I N G                    #
  #############################################################################
  test 'do not create version if nothing changed' do
    old_count = Page::Version.count
    pages(:welcome).save
    assert_equal old_count, Page::Version.count
  end  
  
  test 'do not create version if untracked attribute changed' do
    old_count = Page::Version.count
    pages(:welcome).update_attributes :author=>authors(:sara)
    assert_equal old_count, Page::Version.count
  end
    
  test 'do not create version if custom version check' do
    old_count = Author::Version.count
    authors(:larry).update_attributes :last_name=>'Lessig'
    assert_equal old_count, Author::Version.count
  end

  test 'still save if no new version with custom version check' do
    authors(:larry).update_attributes :last_name=>'Lessig'
    assert_equal 'Lessig', authors(:larry).reload.last_name
  end
  
  #############################################################################
  #                                 F I N D                                   #
  #############################################################################
  test 'find version given number' do
    assert_equal page_versions(:welcome_1), pages(:welcome).find_version(1)
    assert_equal page_versions(:welcome_2), pages(:welcome).find_version(2)
  end
  
  test 'find latest version' do
    assert_equal page_versions(:welcome_2), pages(:welcome).versions.latest
  end
  
  test 'find previous version' do
    assert_equal page_versions(:welcome_1), page_versions(:welcome_2).previous
  end
  
  test 'find next version' do
     assert_equal page_versions(:welcome_2), page_versions(:welcome_1).next
  end
  
  #############################################################################
  #                        B L O C K    E X T E N S I O N                     #
  #############################################################################
  test 'take a block containing ActiveRecord extension' do
    assert_equal authors(:larry), page_versions(:welcome_1).author
  end
  
  #############################################################################
  #                        RECOVER THE CONTENT OF A VERSION                   #
  #############################################################################  
  test 'recover a previous version' do
    versions = pages(:welcome).versions.size
    
    pages(:welcome).recover_version!(1)

    assert_equal versions+1, pages(:welcome).versions.size
    assert_equal pages(:welcome).body, pages(:welcome).versions.first.body    
    assert_equal pages(:welcome).title, pages(:welcome).versions.first.title    
  end
  
  test 'try to recover an unexisting version' do
    versions = pages(:welcome).versions.size

    begin
      pages(:welcome).recover_version!(versions.size+1)
      fail "Version not found should not allow a recover!"
    rescue
    end

  end  
    
end