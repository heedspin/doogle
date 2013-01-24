# == Schema Information
#
# Table name: display_prices
#
#  id                 :integer(4)      not null, primary key
#  display_id         :integer(4)
#  m2m_vendor_id      :string(255)
#  vendor_name        :string(255)
#  vendor_part_number :string(255)
#  preferred_vendor   :boolean(1)
#  start_date         :date
#  last_date          :date
#  quantity1          :integer(4)
#  cost1              :decimal(12, 2)
#  price1             :decimal(12, 2)
#  quantity2          :integer(4)
#  cost2              :decimal(12, 2)
#  price2             :decimal(12, 2)
#  quantity3          :integer(4)
#  cost3              :decimal(12, 2)
#  price3             :decimal(12, 2)
#  quantity4          :integer(4)
#  cost4              :decimal(12, 2)
#  price4             :decimal(12, 2)
#  quantity5          :integer(4)
#  cost5              :decimal(12, 2)
#  price5             :decimal(12, 2)
#  quantity6          :integer(4)
#  cost6              :decimal(12, 2)
#  price6             :decimal(12, 2)
#  quantity7          :integer(4)
#  cost7              :decimal(12, 2)
#  price7             :decimal(12, 2)
#  quantity8          :integer(4)
#  cost8              :decimal(12, 2)
#  price8             :decimal(12, 2)
#  import_token       :string(255)
#  notes              :text
#  created_at         :datetime
#  updated_at         :datetime
#

require 'plutolib/logger_utils'

class Doogle::DisplayPrice < Doogle::Base
  include Plutolib::LoggerUtils
  belongs_to :display, :class_name => 'Doogle::Display'
  belongs_to :m2m_vendor, :class_name => 'M2m::Vendor', :primary_key => 'fvendno'
  validates_presence_of :start_date, :display, :vendor_name
  
  scope :by_start_date_desc, :order => 'display_prices.start_date desc'  
  scope :display, lambda { |display|
    where(:display_id => display.id)
  }
  scope :import_token, lambda { |import_token|
    where(:import_token => import_token)
  }
  scope :active_on, lambda { |date|
    where(['display_prices.start_date <= ? and (display_prices.last_date >= ? or display_prices.last_date is null)', date, date])
  }
  after_save :unset_preferred_vendor
  def unset_preferred_vendor
    if self.preferred_vendor
      Doogle::DisplayPrice.update_all({:preferred_vendor => false}, ['display_prices.id != ? and display_prices.preferred_vendor = true', self.id])
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
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["display_prices.id != ? and display_prices.display_id = ? and display_prices.last_date is null and display_prices.start_date < ? and display_prices.vendor_name = ?", self.id, self.display_id, self.last_date, self.vendor_name])
    else
      self.class.update_all({:last_date => self.start_date.advance(:days => -1)}, ["display_prices.id != ? and display_prices.display_id = ? and display_prices.last_date is null and display_prices.vendor_name = ?", self.id, self.display_id, self.vendor_name])
    end
  end
  
  def self.clone_price(source_price, source_display, destination_display)
    price = source_price.clone
    price.display_id = destination_display.id
    price.notes = "Cloned from #{source_display.model_number}"
    price.save!
    price
  end  
  
  TOTAL_LEVELS=8
  def levels
    @levels ||= (1..TOTAL_LEVELS).map { |x| Doogle::PriceLevel.new(x, self) }
  end
  def levels_used
    self.levels.select(&:used?)
  end
  def clear_levels
    (1..TOTAL_LEVELS).each do |x|
      self.send("quantity#{x}=", nil)
      self.send("cost#{x}=", nil)
      self.send("price#{x}=", nil)
    end
    @levels = []    
  end
  def next_level
    if @levels.size == TOTAL_LEVELS
      raise "Out of room!"
    end
    level = Doogle::PriceLevel.new(@levels.size + 1, self)
    @levels.push level
    level
  end
  def set_next_level(quantity, cost, price)
    level = self.next_level
    level.quantity = quantity
    level.cost = cost
    level.price = price
    level
  end
  
end
