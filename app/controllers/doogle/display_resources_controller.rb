class Doogle::DisplayResourcesController < ApplicationController
  skip_before_filter :require_login
  respond_to :json

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
    @display = build_object
    if @display.save
      render :json => @display
      # redirect_to :controller => 'doogle/display_resources', :action => 'show', :id => @display.id
    else
      render :json => {:errors => @display.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def update
    @display = current_object
    if @display.update_attributes(params[:display_resource])
      render :json => @display
    else
      render :json => {:errors => @display.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    @display = current_object
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

    before_filter :require_api_key
    def require_api_key
      (params[:api_key] == AppConfig.doogle_api_key)
    end

    def build_object
      if @current_object.nil?
        id = nil
        if display_params = params[:display_resource]
          id = display_params.delete(:id)
        end
        @current_object = Doogle::Display.new(display_params)
        @current_object.id = id if id
      end
      @current_object
    end
end
