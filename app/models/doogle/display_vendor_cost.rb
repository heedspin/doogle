# == Schema Information
#
# Table name: display_vendor_costs
#
#  id                 :integer(4)      not null, primary key
#  display_id         :integer(4)
#  m2m_vendor_id      :string(255)
#  vendor_name        :string(255)
#  vendor_part_number :string(255)
#  preferred_vendor   :boolean(1)
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

class Doogle::DisplayVendorCost < Doogle::Base
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :m2m_vendor, :class_name => 'M2m::Vendor', :primary_key => 'fvendno'
  belongs_to_active_hash :approval_status, :class_name => 'Doogle::ApprovalStatus'
  include Doogle::HasQuantityValueLevels
  validates_presence_of :start_date, :display, :approval_status, :vendor_name

  scope :by_start_date_desc, :order => 'display_vendor_costs.start_date desc'  

  after_save :unset_preferred_vendor
  def unset_preferred_vendor
    if self.preferred_vendor
      Doogle::DisplayVendorCost.update_all({:preferred_vendor => false}, ['display_vendor_costs.id != ? and display_vendor_costs.preferred_vendor = true', self.id])
    end
  end

  before_save :set_m2m_vendor
  def set_m2m_vendor
    if self.vendor_name.present? and (self.m2m_vendor_id.nil? or self.m2m_vendor.nil? or (self.m2m_vendor.name != self.vendor_name))
      self.m2m_vendor = M2m::Vendor.with_name(self.vendor_name).first
    end
    true
  end
  
  after_save :set_last_dates
  def set_last_dates
    if self.last_date
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["#{self.class.table_name}.id != ? and #{self.class.table_name}.last_date is null and #{self.class.table_name}.start_date < ? and #{self.class.table_name}.vendor_name = ?", self.id, self.last_date, self.vendor_name])
    else
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["#{self.class.table_name}.id != ? and #{self.class.table_name}.last_date is null and #{self.class.table_name}.vendor_name = ?", self.id, self.vendor_name])
    end
  end  
  
end
