# == Schema Information
#
# Table name: display_interface_types
#
#  id                :integer          not null, primary key
#  display_id        :integer
#  interface_type_id :integer
#

class Doogle::DisplayInterfaceType < ActiveRecord::Base
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :interface_type, :class_name => 'Doogle::InterfaceType'
end
