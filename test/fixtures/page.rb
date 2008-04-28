class Page < ActiveRecord::Base
  version_fu :skip=>:creator_id
  
  belongs_to :author
  belongs_to :creator, :class_name=>'Author'
end