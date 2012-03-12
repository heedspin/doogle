require 'active_hash_methods'
class Doogle::DisplayMode < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Positive'},
    {:id => 2, :name => 'Negative'}
  ]
  include ActiveHashMethods
end
