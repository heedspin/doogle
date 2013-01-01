class CreateDoogleSpecVersions < ActiveRecord::Migration
  def up
    create_table :doogle_spec_versions, :force => true do |t|
      t.references :status
      t.references :display
      t.integer  :version
      t.text     :comments
      t.string   :source_specification_file_name
      t.string   :source_specification_content_type
      t.integer  :source_specification_file_size
      t.datetime :source_specification_updated_at
      t.string   :specification_file_name
      t.string   :specification_content_type
      t.integer  :specification_file_size
      t.datetime :specification_updated_at
      t.boolean  :specification_public
      t.datetime :datasheet_updated_at
      t.string   :datasheet_file_name
      t.string   :datasheet_content_type
      t.integer  :datasheet_file_size
      t.datetime :datasheet_updated_at
      t.boolean  :datasheet_public
      t.datetime :drawing_updated_at
      t.string   :drawing_file_name
      t.string   :drawing_content_type
      t.integer  :drawing_file_size
      t.datetime :drawing_updated_at
      t.boolean  :drawing_public
      t.integer  :updated_by_id
      t.timestamps
    end
  end

  def down
    drop_table :doogle_spec_versions
  end
end