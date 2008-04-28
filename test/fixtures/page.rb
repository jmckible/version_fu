class Page < ActiveRecord::Base
  version_fu :skip=>:creator_id
end