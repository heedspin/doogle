if Rails::VERSION::MAJOR < 5
  require 'doogle_config'

  class Doogle::LogsController < Doogle::DoogleController
    filter_access_to :all

    def index
      @display_logs = Doogle::DisplayLog.by_date_desc.scoped(:include => 'display').paginate(:page => params[:page], :per_page => 50)
    end
  end
end
