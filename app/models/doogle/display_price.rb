# == Schema Information
#
# Table name: display_prices
#
#  id                 :integer(4)      not null, primary key
#  display_id         :integer(4)
#  start_date         :date
#  last_date          :date
#  approval_status_id :integer(4)
#  quantity1          :integer(4)
#  value1             :decimal(12, 4)
#  quantity2          :integer(4)
#  value2             :decimal(12, 4)
#  quantity3          :integer(4)
#  value3             :decimal(12, 4)
#  quantity4          :integer(4)
#  value4             :decimal(12, 4)
#  quantity5          :integer(4)
#  value5             :decimal(12, 4)
#  quantity6          :integer(4)
#  value6             :decimal(12, 4)
#  quantity7          :integer(4)
#  value7             :decimal(12, 4)
#  quantity8          :integer(4)
#  value8             :decimal(12, 4)
#  notes              :text
#  created_at         :datetime
#  updated_at         :datetime
#

class Doogle::DisplayPrice < Doogle::Base
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to_active_hash :approval_status, :class_name => 'Doogle::ApprovalStatus'
  validates_presence_of :start_date, :display, :approval_status
  include Doogle::HasQuantityValueLevels
  
  scope :by_start_date_desc, :order => 'display_prices.start_date desc'  

  after_save :set_last_dates
  def set_last_dates
    if self.last_date
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["#{self.class.table_name}.id != ? and #{self.class.table_name}.last_date is null and #{self.class.table_name}.start_date < ?", self.id, self.last_date])
    else
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["#{self.class.table_name}.id != ? and #{self.class.table_name}.last_date is null", self.id])
    end
  end  
end
