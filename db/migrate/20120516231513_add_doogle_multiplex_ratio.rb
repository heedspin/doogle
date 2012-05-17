class AddDoogleMultiplexRatio < ActiveRecord::Migration
  def up
    add_column :displays, :multiplex_ratio, :integer
  end

  def down
    remove_column :displays, :multiplex_ratio
  end
end