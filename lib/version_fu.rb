module VersionFu
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    
    def version_fu(options={})
      
    end
    
  end
  
  module InstanceMethods
  end
  
end