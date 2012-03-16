require 'active_hash_methods'
class Doogle::MaskType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Has Mask'},
    {:id => 2, :name => 'No Mask'},
  ]
  include ActiveHashMethods
end
