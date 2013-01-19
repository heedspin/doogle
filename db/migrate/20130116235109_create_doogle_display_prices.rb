class CreateDoogleDisplayPrices < ActiveRecord::Migration
  def up
    create_table :display_prices, :force => true do |t|
      t.references :display
      t.date :start_date
      t.date :last_date
      t.references :approval_status
      (1..Doogle::HasQuantityValueLevels::TOTAL).each do |x|
        t.integer "quantity#{x}"
        t.decimal "value#{x}", :precision => 12, :scale => 4
      end
      t.text :notes
      t.timestamps
    end
  end

  def down
    drop_table :display_prices
  end
end