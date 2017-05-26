require 'plutolib/active_hash_methods'
class Doogle::TftType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'TN'},
    {:id => 2, :name => 'IPS'},
    {:id => 3, :name => 'MVA'},
    {:id => 4, :name => 'OVA'},
    {:id => 5, :name => 'EWV'},
    {:id => 6, :name => 'E-Ink'}
  ]
  include Plutolib::ActiveHashMethods
end
