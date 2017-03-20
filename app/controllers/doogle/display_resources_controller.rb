class Doogle::DisplayResourcesController < ApplicationController
  include ActionController::MimeResponds

  skip_before_action :verify_authenticity_token

  def index
    render :text => 'hello sync displays'
  end

  def show
    @display = Doogle::Display.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => @display.to_json
      end
    end
  end

  def create
    params.require(:display_resource).permit!
    id = nil
    if display_params = params[:display_resource]
      id = display_params.delete(:new_display_id)
    end
    @display = Doogle::Display.new(display_params)
    @display.id = id if id
    if @display.save
      render :json => @display
      # redirect_to :controller => 'doogle/display_resources', :action => 'show', :id => @display.id
    else
      logger.error "Failed to create display #{@display.id}: " + @display.errors.full_messages.join("\n")
      render :json => {:errors => @display.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def update
    params.require(:display_resource).permit!
    @display = Doogle::Display.find(params[:id])
    if @display.update_attributes(params[:display_resource])
      render :json => @display
    else
      logger.error "Failed to update display #{@display.id}: " + @display.errors.full_messages.join("\n")
      render :json => {:errors => @display.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    @display = Doogle::Display.find(params[:id])
    @display.destroy
    render :json => @display
  end

  protected

  def model_class
    Doogle::Display
  end
  def model_name
    'display_resource'
  end

  before_action :require_api_key
  def require_api_key
    unless (params[:api_key] == AppConfig.doogle_api_key)
      logger.error "Submitted api_key != #{AppConfig.doogle_api_key}"
      render :plain => 'not authorized', :status => 403
    end
  end
end
