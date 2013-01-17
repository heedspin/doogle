# == Schema Information
#
# Table name: display_vendor_costs
#
#  id                 :integer(4)      not null, primary key
#  display_id         :integer(4)
#  m2m_vendor_id      :string(255)
#  vendor_name        :string(255)
#  preferred_vendor   :boolean(1)
#  start_date         :date
#  last_date          :date
#  approval_status_id :integer(4)
#  quantity1          :integer(4)
#  cost1              :decimal(12, 4)
#  quantity2          :integer(4)
#  cost2              :decimal(12, 4)
#  quantity3          :integer(4)
#  cost3              :decimal(12, 4)
#  quantity4          :integer(4)
#  cost4              :decimal(12, 4)
#  quantity5          :integer(4)
#  cost5              :decimal(12, 4)
#  quantity6          :integer(4)
#  cost6              :decimal(12, 4)
#  notes              :text
#  created_at         :datetime
#  updated_at         :datetime
#

class Doogle::DisplayVendorCost < ActiveRecord::Base
  belongs_to :display, :class_name => 'Doogle::Display'
end
