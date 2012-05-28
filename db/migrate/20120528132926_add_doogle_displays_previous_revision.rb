class AddDoogleDisplaysPreviousRevision < ActiveRecord::Migration
  def up
    add_column :displays, :previous_revision_id, :integer
  end

  def down
    remove_column :displays, :previous_revision_id
  end
end