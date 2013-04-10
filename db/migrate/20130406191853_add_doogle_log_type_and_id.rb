class AddDoogleLogTypeAndId < ActiveRecord::Migration
  def up
    add_column :display_logs, :log_type_id, :integer
    add_column :display_logs, :object_id, :string
    add_column :display_logs, :event_time, :datetime
    execute 'update display_logs set event_time = updated_at'
    execute "update display_logs set log_type_id = #{Doogle::LogType.create.id} where summary = 'Create'"
    execute "update display_logs set log_type_id = #{Doogle::LogType.update.id} where summary = 'Update'"
    execute "update display_logs set log_type_id = #{Doogle::LogType.destroy.id} where summary = 'Destroy'"
    execute "update display_logs set log_type_id = #{Doogle::LogType.vendor.id} where summary like '%Vendor%'"
    execute "update display_logs set log_type_id = #{Doogle::LogType.spec.id} where summary like '%Spec%'"
    Doogle::DisplayLog.reset_column_information
    Sales::Opportunity.all.each(&:create_display_logs)
    Sales::QuoteItem.all.each(&:create_display_log)
  end

  def self.down
    remove_column :display_logs, :event_time
    remove_column :display_logs, :object_id
    remove_column :display_logs, :log_type_id
  end
end