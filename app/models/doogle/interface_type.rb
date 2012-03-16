# == Schema Information
#
# Table name: doogle_interface_types
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#
require 'static_model'

class Doogle::InterfaceType < ApplicationModel
  set_table_name 'doogle_interface_types'
  include StaticModel
  self.data = [
    {:id => 1, :name => 'SPI'},
    {:id => 2, :name => 'Parallel'},
    {:id => 3, :name => 'I2C'},
    {:id => 4, :name => 'LVDS'},
    {:id => 5, :name => 'RGB'},
    {:id => 6, :name => 'CPU'}
  ]
end
