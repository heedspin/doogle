require 'plutolib/active_hash_methods'
class Doogle::Status < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Unfinished / Draft', :cmethod => 'draft'},
    {:id => 2, :name => 'Complete', :cmethod => 'published'},
    {:id => 3, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
