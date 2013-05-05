# == Schema Information
#
# Table name: display_logs
#
#  id          :integer          not null, primary key
#  display_id  :integer
#  summary     :string(255)
#  details     :text
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  log_type_id :integer
#  object_id   :string(255)
#  event_time  :datetime
#

require 'active_hash'

class Doogle::DisplayLog < ApplicationModel
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :user
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :log_type, :class_name => 'Doogle::LogType'
  belongs_to :opportunity, :class_name => 'Sales::Opportunity', :foreign_key => 'object_id'
  belongs_to :quote, :class_name => 'Sales::Quote', :foreign_key => 'object_id'
  
  scope :by_date_desc, :order => 'display_logs.event_time desc'
  scope :for_display, lambda { |display|
    display_id = display.is_a?(Doogle::Display) ? display.id : display
    {
      :conditions => { :display_id => display_id }
    }
  }  
  scope :with_object_id, lambda { |oid|
    where(:object_id => oid)
  }
  scope :log_type, lambda { |*log_types|
    if log_types.size == 1
      where(:log_type_id => log_types.first.id)
    else
      where ['log_type_id in (?)', log_types.map(&:id)]
    end
  }
  scope :after, lambda { |after_date|
    where ['display_logs.event_time >= ?', after_date]
  }
  before_create :set_event_time
  def set_event_time
    self.event_time ||= Time.now
  end
end
