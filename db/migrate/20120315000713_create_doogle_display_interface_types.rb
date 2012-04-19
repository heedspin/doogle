class CreateDoogleDisplayInterfaceTypes < ActiveRecord::Migration
  def change
    create_table :display_interface_types, :force => true do |t|
      t.references :display
      t.references :interface_type
    end
    create_table :doogle_interface_types, :force => true do |t|
      t.string :name
    end
  end
end