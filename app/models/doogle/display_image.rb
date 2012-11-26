require 'plutolib/active_hash_methods'
class Doogle::DisplayImage < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Positive'},
    {:id => 2, :name => 'Negative'}
  ]
  include Plutolib::ActiveHashMethods
end
