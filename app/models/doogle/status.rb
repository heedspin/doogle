require 'plutolib/active_hash_methods'
class Doogle::Status < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Unfinished / Draft', :cmethod => 'draft'},
    {:id => 2, :name => 'Complete', :cmethod => 'published'},
    {:id => 3, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
  
  def self.obsolete_draft_status
    Doogle::Display.connection.execute "update displays set publish_to_web = false where status_id = 1"
    Doogle::Display.connection.execute "update displays set status_id = 2 where status_id = 1"
    Doogle::Display.connection.execute "update displays set on_master_list = true where status_id = 2"
  end
end
