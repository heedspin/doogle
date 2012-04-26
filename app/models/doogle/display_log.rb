# == Schema Information
#
# Table name: display_logs
#
#  id         :integer(4)      not null, primary key
#  display_id :integer(4)
#  summary    :string(255)
#  details    :text
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Doogle::DisplayLog < ActiveRecord::Base
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :user
  
  scope :by_date_desc, :order => 'display_logs.created_at desc'
end
