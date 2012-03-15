require 'active_hash_methods'
class Doogle::InterfaceType < ActiveHash::Base
  self.data = [
    {:id => 1, :name => 'SPI'},
    {:id => 2, :name => 'Parallel'},
    {:id => 3, :name => 'I2C'},
  ]
  include ActiveHashMethods
end
