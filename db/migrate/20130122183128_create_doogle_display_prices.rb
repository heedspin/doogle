class CreateDoogleDisplayPrices < ActiveRecord::Migration
  def up
    create_table :display_prices, :force => true do |t|
      t.references :display
      t.string :m2m_vendor_id
      t.string :vendor_name
      t.string :vendor_part_number
      t.boolean :preferred_vendor
      t.date :start_date
      t.date :last_date
      (1..Doogle::DisplayPrice::TOTAL_LEVELS).each do |x|
        t.integer "quantity#{x}"
        t.decimal "cost#{x}", :precision => 12, :scale => 2
        t.decimal "price#{x}", :precision => 12, :scale => 2
      end
      t.string :import_token
      t.text :notes
      t.timestamps
    end
  end

  def down
    drop_table :display_prices
  end
end