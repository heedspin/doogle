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
#  price1             :decimal(12, 4)
#  quantity2          :integer(4)
#  price2             :decimal(12, 4)
#  quantity3          :integer(4)
#  price3             :decimal(12, 4)
#  quantity4          :integer(4)
#  price4             :decimal(12, 4)
#  quantity5          :integer(4)
#  price5             :decimal(12, 4)
#  quantity6          :integer(4)
#  price6             :decimal(12, 4)
#  notes              :text
#  created_at         :datetime
#  updated_at         :datetime
#

require 'active_hash'

class Doogle::DisplayPrice < ApplicationModel
  belongs_to :display, :class_name => 'Doogle::Display'
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :approval_status, :class_name => 'Doogle::ApprovalStatus'
  validates_presence_of :start_date, :display, :approval_status
  
  scope :by_start_date_desc, :order => 'display_prices.start_date desc'
  
  class Level
    attr_accessor :index, :display_price, :quantity_column, :price_column
    def initialize(index, display_price)
      @index = index
      @display_price = display_price
      @quantity_column = "quantity#{index}"
      @price_column = "price#{index}"
    end
    def quantity
      @display_price.send(@quantity_column)
    end
    def price
      @display_price.send(@price_column)
    end
    def value?
      self.quantity.present? && self.price.present? && (self.quantity > 0) && (self.price > 0)
    end
    def quantity_label
      Doogle::DisplayPrice.human_attribute_name(:quantity) + " #{@index}"
    end
    def price_label
      Doogle::DisplayPrice.human_attribute_name(:price) + " #{@index}"
    end
  end
  def levels
    @levels ||= (1..6).map { |x| Level.new(x, self) }
  end
  def levels_used
    self.levels.select(&:value?)
  end
  
  after_save :set_last_dates
  def set_last_dates
    if self.last_date
      Doogle::DisplayPrice.update_all({:last_date => self.start_date.advance(:days => -1)}, ['display_prices.id != ? and (display_prices.last_date is null or display_prices.last_date >= ?) and display_prices.start_date < ?', self.id, self.start_date, self.last_date])
    else
      Doogle::DisplayPrice.update_all({:last_date => self.start_date.advance(:days => -1)}, ['display_prices.id != ? and (display_prices.last_date is null or display_prices.last_date >= ?)', self.id, self.start_date])
    end
  end
end
