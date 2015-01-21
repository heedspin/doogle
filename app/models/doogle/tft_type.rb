require 'plutolib/active_hash_methods'
class Doogle::TftType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'TN'},
    {:id => 2, :name => 'IPS'},
    {:id => 3, :name => 'MVA'},
    {:id => 4, :name => 'WVO-Film'}
  ]
  include Plutolib::ActiveHashMethods
end
