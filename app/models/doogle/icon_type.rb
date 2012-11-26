require 'plutolib/active_hash_methods'
class Doogle::IconType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Has Icons'},
    {:id => 2, :name => 'No Icons'},
  ]
  include Plutolib::ActiveHashMethods
end
