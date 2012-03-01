require 'active_hash_methods'
class Doogle::TimingControllerType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Built In'}
  ]
  include ActiveHashMethods
end
