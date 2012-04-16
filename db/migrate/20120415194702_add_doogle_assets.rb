class AddDoogleAssets < ActiveRecord::Migration
  def up
    add_column :displays, :datasheet_public, :boolean
    add_column :displays, :source_specification_file_name, :string
    add_column :displays, :source_specification_content_type, :string
    add_column :displays, :source_specification_file_size, :integer
    add_column :displays, :source_specification_updated_at, :datetime
    add_column :displays, :specification_file_name, :string
    add_column :displays, :specification_content_type, :string
    add_column :displays, :specification_file_size, :integer
    add_column :displays, :specification_updated_at, :datetime
    add_column :displays, :specification_public, :boolean
    add_column :displays, :drawing_file_name, :string
    add_column :displays, :drawing_content_type, :string
    add_column :displays, :drawing_file_size, :integer
    add_column :displays, :drawing_updated_at, :datetime
    add_column :displays, :drawing_public, :boolean    
  end

  def down
  end
end