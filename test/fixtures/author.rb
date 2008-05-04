class Author < ActiveRecord::Base
  
  version_fu
  def create_new_version?
    first_name_change && last_name_changed? 
  end
  
end