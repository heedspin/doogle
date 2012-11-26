require 'plutolib/active_hash_methods'
class Doogle::Status < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Draft'},
    {:id => 2, :name => 'Published'},
    {:id => 3, :name => 'Deleted'}
  ]
  include Plutolib::ActiveHashMethods
end
