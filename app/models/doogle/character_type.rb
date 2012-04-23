require 'active_hash_methods'
class Doogle::CharacterType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => '7 Segment'},
    {:id => 2, :name => '14 Segment'},
    {:id => 3, :name => '16 Segment'},
    {:id => 4, :name => '5 x 7 Dot'},
    {:id => 5, :name => '5 x 8 Dot'},
    {:id => 7, :name => 'Mosaic'},
    {:id => 8, :name => 'Bar Graph'},
  ]
  include ActiveHashMethods
end
