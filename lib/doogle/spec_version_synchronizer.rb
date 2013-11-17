require 'plutolib/logger_utils'

class Doogle::SpecVersionSynchronizer
  include Plutolib::LoggerUtils

  def initialize(spec_version_id=nil)
    @spec_version_id = spec_version_id
    @web_creates = 0
    @web_updates = 0
    @web_no_change = 0
    @web_errors = 0
    @web_deletes = 0
  end

  def run_in_background!
    if @spec_version_id
      self.send_later(:sync_single_display)
    else
      self.send_later(:sync_all_displays)
    end
  end

  # require 'doogle/web_synchronizer' ; puts Doogle::WebSynchronizer.new.sync_all_displays
  def sync_all_displays
    # TODO: add time window here?
    Doogle::SpecVersion.find_each do |spec_version|
      sync_single_display(spec_version)
    end
    true
  end

  def sync_single_display(spec_version=nil)
    spec_version ||= Doogle::SpecVersion.find(@spec_version_id)
    case spec_version.sync_to_web
    when :create
      @web_creates += 1
    when :update
      @web_updates += 1
    when :delete
      @web_deletes += 1
    when :no_change
      @web_no_change += 1
    when :error
      @web_errors += 1
    end
    true
  end

  def results
    <<-TEXT
    #{@web_creates} creates
    #{@web_updates} updates
    #{@web_deletes} deletes
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
