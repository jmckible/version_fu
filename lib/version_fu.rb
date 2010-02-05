require 'version_fu/version_fu'
ActiveRecord::Base.class_eval { include VersionFu }