class AddDoogleGammaRequired < ActiveRecord::Migration
  def up
    add_column :displays, :gamma_required, :boolean
  end

  def self.down
    remove_column :displays, :gamma_required
  end
end