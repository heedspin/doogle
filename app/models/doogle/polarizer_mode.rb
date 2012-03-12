require 'active_hash_methods'
class Doogle::PolarizerMode < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Transflective'},
    {:id => 2, :name => 'Reflective'},
    {:id => 3, :name => 'Transmissive'}
  ]
  include ActiveHashMethods
end
