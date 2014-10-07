class AddDoogleDisplayCtpIc < ActiveRecord::Migration
  def change
  	add_column :displays, :ctp_ic, :string
  end
end
