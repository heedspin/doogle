class AddDoogleDisplayPriceVendorRevision < ActiveRecord::Migration
  def up
    add_column :display_prices, :vendor_revision, :string
  end

  def down
    remove_column :display_prices, :vendor_revision
  end
end