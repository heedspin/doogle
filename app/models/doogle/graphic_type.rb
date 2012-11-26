require 'plutolib/active_hash_methods'
class Doogle::GraphicType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Character'},
    {:id => 2, :name => 'Graphic'}
  ]
  include Plutolib::ActiveHashMethods
end
