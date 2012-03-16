# == Schema Information
#
# Table name: display_interface_types
#
#  id                :integer(4)      not null, primary key
#  display_id        :integer(4)
#  interface_type_id :integer(4)
#

class Doogle::DisplayInterfaceType < ApplicationModel
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :interface_type, :class_name => 'Doogle::InterfaceType'
end
