class CreateDoogleDisplayVendorCosts < ActiveRecord::Migration
  def up
    create_table :display_vendor_costs, :force => true do |t|
      t.references :display
      t.string :m2m_vendor_id
      t.string :vendor_name
      t.boolean :preferred_vendor
      t.date :start_date
      t.date :last_date
      t.references :approval_status
      (1..6).each do |x|
        t.integer "quantity#{x}"
        t.decimal "cost#{x}", :precision => 12, :scale => 4
      end
      t.text :notes
      t.timestamps
    end
  end

  def down
    drop_table :display_vendor_costs
  end
end