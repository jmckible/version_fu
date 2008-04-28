module VersionFu
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def version_fu(options={})
      return if self.included_modules.include? VersionFu::InstanceMethods
      __send__ :include, VersionFu::InstanceMethods

      cattr_accessor :versioned_class_name, :versioned_foreign_key, :versioned_table_name, 
                     :versioned_inheritance_column, :version_column, :non_versioned_columns

      self.versioned_class_name         = "Version"
      self.versioned_foreign_key        = self.to_s.foreign_key
      self.versioned_table_name         = "#{table_name_prefix}#{base_class.name.demodulize.underscore}_versions#{table_name_suffix}"
      self.versioned_inheritance_column = "versioned_#{inheritance_column}"
      self.version_column               = 'version'
      
      # Configure which attributes to track
      self.non_versioned_columns = [self.primary_key, inheritance_column, 'version', 'lock_version', versioned_inheritance_column, 'created_at', 'updated_at']
      unless options[:skip].nil?
        if options[:skip].is_a?(Array)
          self.non_versioned_columns = non_versioned_columns + options[:skip].collect(&:to_s)
        else
          self.non_versioned_columns << options[:skip].to_s
        end
      end

      # Setup versions association
      class_eval do
        has_many :versions, :class_name  => "#{self.to_s}::#{versioned_class_name}",
                            :foreign_key => versioned_foreign_key,
                            :order       => 'version',
                            :dependent   => :delete_all do
          def latest
            find :first, :order=>'version desc'
          end                    
        end

        before_save :setup_revision
      end

      # Versioned Model
      const_set(versioned_class_name, Class.new(ActiveRecord::Base)).class_eval do
        def self.reloadable? ; false ; end
        # find first version before the given version
        def self.before(version)
          find :first, :order => 'version desc',
            :conditions => ["#{original_class.versioned_foreign_key} = ? and version < ?", version.send(original_class.versioned_foreign_key), version.version]
        end

        # find first version after the given version.
        def self.after(version)
          find :first, :order => 'version',
            :conditions => ["#{original_class.versioned_foreign_key} = ? and version > ?", version.send(original_class.versioned_foreign_key), version.version]
        end

        def previous
          self.class.before(self)
        end

        def next
          self.class.after(self)
        end

        def versions_count
          page.version
        end
      end

      versioned_class.cattr_accessor :original_class
      versioned_class.original_class = self
      versioned_class.set_table_name versioned_table_name
      versioned_class.belongs_to self.to_s.demodulize.underscore.to_sym, 
        :class_name  => "::#{self.to_s}", 
        :foreign_key => versioned_foreign_key
    end
    
    def versioned_class
      const_get versioned_class_name
    end
    
  end


  module InstanceMethods
    
    def find_version(number)
      versions.find :first, :conditions=>{:version=>number}
    end
    
    def versioned_attributes
      self.attributes.keys - self.non_versioned_columns
    end
    
    def versioned_column_changed?
      versioned_attributes.detect {|a| __send__ "#{a}_changed?"}
    end
    
    def setup_revision
      instatiate_revision if versioned_column_changed?
    end
    
    def instatiate_revision
      new_version = versions.build
      versioned_attributes.each do |attribute|
        new_version.__send__ "#{attribute}=", __send__(attribute)
      end
      if new_record?
        # In case version column does not default to 1
        new_version.version = 1
        self.version = 1
      else
        version_number = version + 1
        new_version.version = version_number
        self.version = version_number
      end
    end
    
  end
  
end