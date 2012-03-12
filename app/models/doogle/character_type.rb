require 'active_hash_methods'
class Doogle::CharacterType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Segment'},
    {:id => 2, :name => '5 x 7'}
  ]
  include ActiveHashMethods
end
