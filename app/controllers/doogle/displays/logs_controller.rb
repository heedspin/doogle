if Rails::VERSION::MAJOR < 5
  class Doogle::Displays::LogsController < Doogle::DoogleController
    filter_access_to :all, :context => :doogle_display_logs

    def index
      @display = parent_object
      @display_logs = Doogle::DisplayLog.for_display(@display).by_date_desc.paginate(:page => params[:page], :per_page => 50)
      @comment ||= @display.logs.build(:log_type => Doogle::LogType.comment)
    end

    def create
      @display = parent_object
      @comment = build_object
      @comment.summary = @comment.log_type.try(:name)
      @comment.user_id = current_user.id
      if @comment.save
        flash[:notice] = 'Created Comment'
        redirect_to doogle_display_display_logs_url(@display)
      else
        flash[:error] = 'Failed to create comment'
        index
        render 'index'
      end
    end

    def destroy
      @display = parent_object
      @display_log = current_object
      destination = doogle_display_display_logs_url(@display)
      if @display_log.log_type.try(:editable?)
        @display_log.destroy
        respond_to do |format|
          format.html {
            flash[:notice] = "#{@display_log.log_type.try(:name)} deleted."
            redirect_to destination
          }
          format.js {
            render :json => { :location => destination }.to_json
          }
        end
      else
        logger.error "Tried to delete display log #{@display_log.id} #{@display_log.log_type.try(:name)}"
        respond_to do |format|
          format.html {
            flash[:notice] = "#{@display_log.log_type.try(:name)} not deleted."
            redirect_to destination
          }
          format.js {
            render :json => { :location => destination }.to_json
          }
        end
      end
    end

    protected

    def model_name
      :doogle_display_log
    end

    def parent_object
      @parent_object ||= Doogle::Display.find(params[:display_id])
    end

    def build_object
      @current_object ||= parent_object.logs.build(params.require(:doogle_display_log).permit!)
    end

    def current_object
      @current_object ||= Doogle::DisplayLog.find(params[:id])
    end

  end
end
