require 'logger_utils'

class Doogle::WebSynchronizer
  include LoggerUtils

  def initialize(display=nil)
    @display_id = display.id
    @web_creates = 0
    @web_updates = 0
    @web_no_change = 0
    @web_errors = 0
  end

  def run_in_background!
    if @display_id
      self.send_later(:sync_single_display)
    else
      self.send_later(:sync_all_displays)
    end
  end

  # require 'doogle/display_synchronizer' ; puts Doogle::WebSynchronizer.new.sync_all_displays
  def sync_all_displays
    # TODO: add time window here?
    Doogle::Display.find_each do |display|
      sync_single_display(display)
    end
    self.results
  end

  def sync_single_display(display=nil)
    display ||= Doogle::Display.find(@display_id)
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

  def results
    <<-TEXT
    #{@web_creates} creates
    #{@web_updates} updates
    #{@web_no_change} no changes
    #{@web_errors} errors
    TEXT
  end

  def success(job)
    log(results)
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end
end
