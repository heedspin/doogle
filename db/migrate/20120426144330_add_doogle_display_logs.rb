class AddDoogleDisplayLogs < ActiveRecord::Migration
  def up
    create_table :display_logs, :force => true do |t|
      t.references :display
      t.string :summary
      t.text :details
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :display_logs
  end
end