require 'plutolib/to_xls'

class Doogle::IncompleteDisplayList
  include Plutolib::ToXls

  def xls_filename
    'incomplete_display_list.xls'
  end

  def xls_sheet_name
    'Incomplete Displays'
  end

  def xls_initialize
    xls_field('Notes') { |d| d.original_opportunity.try(:safe_title) }
    xls_field('Created Date') { |d| d.created_at }
    xls_field('Model Number') { |d| d.model_number }
    xls_field('X Num') { |d| d.original_xnumber }
    xls_field('Owner') { |d| d.original_opportunity.try(:owner).try(:first_name) }
    xls_field('Why') { |d| d.why.present? ? 'X' : '' }
    xls_field('Original Customer') { |d| d.original_customer_name.present? ? 'X' : '' }
    xls_field('Vendor') { |d| d.prices.count > 0 ? 'X' : '' }
    (1..3).each do |index|
	    xls_field("Pricing #{index}") { |d| 
	    	if p = d.prices.active.order(:id)[index-1]
	    		(p.cost1.present? and p.notes.present?) ? 'X' : '' 
	    	else
	    		'n/a'
	    	end
	   	}
		end
    xls_field('Spec / Datasheet') { |d| d.spec_versions.count > 0 ? 'X' : '' }
  end

  def xls_data
  	@displays = {}
  	start_date = Date.current.advance(:days => -45)
  	Doogle::Display.not_deleted.created_after(start_date).where('displays.why is null or displays.why = \'\'').each do |d|
  		@displays[d.id] ||= d
  	end
  	Doogle::Display.not_deleted.created_after(start_date).without_displays(@displays.values).where('displays.original_xnumber is null or displays.original_xnumber = \'\'').each do |d|
  		@displays[d.id] ||= d
  	end
  	Doogle::Display.not_deleted.created_after(start_date).without_displays(@displays.values).where('displays.original_customer_name is null or displays.original_customer_name = \'\'').each do |d|
  		@displays[d.id] ||= d
  	end
  	Doogle::Display.not_deleted.created_after(start_date).without_displays(@displays.values).includes(:prices).select('displays.id').group('displays.id').having('count(display_prices.id) = 0').each do |d|
  		@displays[d.id] ||= Doogle::Display.find(d.id)
  	end
  	Doogle::DisplayPrice.not_deleted.active.created_after(start_date).without_displays(@displays.values).includes(:display).where('(display_prices.cost1 is null or display_prices.cost1 = \'\') or (display_prices.notes is null or display_prices.notes = \'\')').each do |p|
  		@displays[p.id] ||= p.display
  	end
  	Doogle::Display.not_deleted.created_after(start_date).without_displays(@displays.values).includes(:spec_versions).select('displays.id').group('displays.id').having('count(doogle_spec_versions.id) = 0').each do |d|
  		@displays[d.id] ||= Doogle::Display.find(d.id)
  	end
  	@displays.values.sort_by { |d| [d.created_at] }.reverse
  end
end