require 'plutolib/active_hash_methods'
class Doogle::BacklightType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'LED'},
    {:id => 2, :name => 'CCFL'},
    {:id => 3, :name => 'EL'}
  ]
  include Plutolib::ActiveHashMethods
end
