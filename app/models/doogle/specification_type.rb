require 'active_hash_methods'
class Doogle::SpecificationType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Complete'}
  ]
  include ActiveHashMethods
end
