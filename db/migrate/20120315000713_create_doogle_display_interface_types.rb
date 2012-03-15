class CreateDoogleDisplayInterfaceTypes < ActiveRecord::Migration
  def up
    create_table :display_interface_types, :force => true do |t|
      t.references :display
      t.references :interface_type
    end
  end

  def down
  end
end