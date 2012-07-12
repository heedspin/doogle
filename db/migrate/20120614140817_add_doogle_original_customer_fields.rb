class AddDoogleOriginalCustomerFields < ActiveRecord::Migration
  def up
    add_column :displays, :original_customer_name, :string
    add_column :displays, :original_customer_part_number, :string
  end

  def down
    remove_column :displays, :original_customer_part_number
    remove_column :displays, :original_customer_name
  end
end