require 'active_hash_methods'
class Doogle::ViewingDirection < ActiveHash::Base
  self.data = [
    {:id => 1, :method => 'twelve', :name => '12 O\'Clock'},
    {:id => 2, :method => 'three', :name => '3 O\'Clock'},
    {:id => 3, :method => 'six', :name => '6 O\'Clock'},
    {:id => 4, :method => 'nine', :name => '9 O\'Clock'},
  ]
  include ActiveHashMethods
end
