ActiveRecord::Schema.define(:version=>0) do
  
  create_table :pages, :force=>true do |t|
    t.column :type, :string
    t.column :version, :integer
    t.column :title, :string, :limit=>255
    t.column :body, :text
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
  
  create_table :page_versions, :force=>true do |t|
    t.column :page_id, :integer
    t.column :version, :integer
    t.column :title, :string, :limit=>255
    t.column :body, :text
    t.column :created_at, :datetime
    t.column :updated_at, :datetime
  end
  
end