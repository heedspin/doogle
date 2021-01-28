# == Schema Information
#
# Table name: doogle_interface_types
#
#  id   :integer          not null, primary key
#  name :string(255)
#

require 'static_model'

class Doogle::InterfaceType < ActiveRecord::Base
  self.table_name = 'doogle_interface_types'
  include StaticModel
  self.data = [
    {:id => 1,  :name => 'SPI'},
    {:id => 2,  :name => 'Parallel'},
    {:id => 3,  :name => 'I2C'},
    {:id => 4,  :name => 'LVDS'},
    {:id => 5,  :name => 'RGB'},
    {:id => 6,  :name => 'CPU'},
    {:id => 7,  :name => 'TTL'},
    {:id => 8,  :name => 'MCU'},
    {:id => 9,  :name => 'PC'},
    {:id => 10, :name => 'MIPI'},
    {:id => 11, :name => 'MPU'},
    {:id => 12, :name => 'Serial'},
    {:id => 13, :name => 'eDP'},
    {:id => 14, :name => 'USB'},
    {:id => 15, :name => 'HDMI'}
  ]
end
