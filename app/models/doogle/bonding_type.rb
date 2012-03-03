require 'active_hash_methods'
class Doogle::BondingType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'COB'},
    {:id => 2, :name => 'COG'},
    {:id => 3, :name => 'TAB'},
    {:id => 4, :name => 'COF'}
  ]
  include ActiveHashMethods
end
