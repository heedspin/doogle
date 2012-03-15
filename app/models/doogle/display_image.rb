require 'active_hash_methods'
class Doogle::DisplayImage < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Positive'},
    {:id => 2, :name => 'Negative'}
  ]
  include ActiveHashMethods
end
