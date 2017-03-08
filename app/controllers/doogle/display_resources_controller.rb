if Rails::VERSION::MAJOR < 5
  class Doogle::DisplayResourcesController < ApplicationController
    respond_to :json
    skip_before_filter :require_login
    skip_before_filter :verify_authenticity_token

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
        logger.error "Failed to create display #{@display.id}: " + @display.errors.full_messages.join("\n")
        render :json => {:errors => @display.errors.full_messages}, :status => :unprocessable_entity
      end
    end

    def update
      @display = current_object
      if @display.update_attributes(params[:display_resource])
        render :json => @display
      else
        logger.error "Failed to update display #{@display.id}: " + @display.errors.full_messages.join("\n")
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
      unless (params[:api_key] == AppConfig.doogle_api_key)
        not_authorized
      end
      true
    end

    def build_object
      if @current_object.nil?
        id = nil
        if display_params = params[:display_resource]
          id = display_params.delete(:new_display_id)
        end
        @current_object = Doogle::Display.new(display_params)
        @current_object.id = id if id
      end
      @current_object
    end
  end
end
