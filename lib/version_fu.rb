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
                            :dependent   => :delete_all

        after_create :save_version_on_create
      end

      # Versioned Model
      const_set(versioned_class_name, Class.new(ActiveRecord::Base)).class_eval do
        def self.reloadable? ; false ; end
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
    def versioned_attributes
      self.attributes.keys - self.non_versioned_columns
    end
    
    def save_version_on_create
      version = versions.build
      versioned_attributes.each do |attribute|
        version.__send__ "#{attribute}=", __send__(attribute)
      end
      version.version = 1
      version.save
      update_attribute :version, 1
    end
    
  end
  
end