class Doogle::Displays::LogsController < Doogle::DoogleController
  filter_access_to :all, :context => :doogle_display_logs

  def index
    @display = parent_object
    @display_logs = Doogle::DisplayLog.for_display(@display).by_date_desc.paginate(:page => params[:page], :per_page => 50)
  end

  protected

    def parent_object
      @parent_object ||= Doogle::Display.find(params[:display_id])
    end

end
