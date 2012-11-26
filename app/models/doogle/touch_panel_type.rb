require 'plutolib/active_hash_methods'
class Doogle::TouchPanelType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'Resistive'},
    {:id => 2, :name => 'Capacitive'},
  ]
  include Plutolib::ActiveHashMethods
end
