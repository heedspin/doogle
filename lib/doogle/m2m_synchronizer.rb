require 'logger_utils'

class Doogle::M2mSynchronizer
  include LoggerUtils
  
  def initialize
    @linked_displays = 0
    @sync_from_erp = 0
    @model_number_change = 0
    @no_match = 0
  end
  
  # require 'doogle/m2m_synchronizer' ; puts Doogle::M2mSynchronizer.new.link_m2m_items
  def link_m2m_items
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
    self.results
  end
  
  def results
    <<-TEXT
    #{@linked_displays} linked displays
    #{@sync_from_erp} displays sync'd from m2m
    #{@model_number_change} model numbers changed
    #{@no_match} m2m items without a display match
    TEXT
  end
end