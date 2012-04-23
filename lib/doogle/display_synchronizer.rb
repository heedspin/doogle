require 'logger_utils'

class Doogle::DisplaySynchronizer
  include LoggerUtils
  
  def initialize
    @linked_displays = 0
    @sync_from_erp = 0
    @model_number_change = 0
    @no_match = 0
    @web_creates = 0
    @web_updates = 0
    @web_no_change = 0
    @web_errors = 0
  end
  
  # require 'doogle/display_synchronizer' ; puts Doogle::DisplaySynchronizer.new.m2m
  def m2m
    M2m::Item.find_each do |item|
      if display = Doogle::Display.where(:erp_id => item.id).first
        log "Display #{display.id} is linked to m2m #{item.part_number}"
        @linked_displays += 1
      elsif display = Doogle::Display.where(:model_number => item.part_number).first
        log "Found display #{display.id} for m2m #{item.part_number}"
        display.sync_from_erp!(item)
        @sync_from_erp += 1
      elsif (item.part_number =~ /(\w\d\d\d\d)\w/) and (display = Doogle::Display.where(:model_number => $1).first)
        log "Found display #{display.id} #{display.model_number} for m2m #{item.part_number}"
        display.sync_from_erp!(item)
        @model_number_change += 1
      else
        log "No display for m2m #{item.part_number}"
        @no_match += 1
      end
    end
    self.m2m_results
  end
  
  def m2m_results
    <<-TEXT
    #{@linked_displays} linked displays
    #{@sync_from_erp} displays sync'd from m2m
    #{@model_number_change} model numbers changed
    #{@no_match} m2m items without a display match
    TEXT
  end
  
  # require 'doogle/display_synchronizer' ; puts Doogle::DisplaySynchronizer.new.web
  def web
    # TODO: add time window here
    Doogle::Display.find_each do |display|
      case display.sync_to_web
      when :create
        @web_creates += 1
      when :update
        @web_updates += 1
      when :no_change
        @web_no_change += 1
      when :error
        @web_errors += 1
      end
    end
    self.web_results
  end
  
  def web_results
    <<-TEXT
    #{@web_creates} creates
    #{@web_updates} updates
    #{@web_no_change} no changes
    #{@web_errors} errors
    TEXT
  end
end