if Rails::VERSION::MAJOR < 5
  class Doogle::SpecVersionResourcesController < ApplicationController
    respond_to :json
    skip_before_filter :require_login
    skip_before_filter :verify_authenticity_token

    def show
      @spec_version = Doogle::SpecVersion.find(params[:id])
      respond_to do |format|
        format.json do
          render :json => @spec_version.to_json
        end
      end
    end

    def create
      @spec_version = build_object
      if @spec_version.save
        render :json => @spec_version
      else
        logger.error "Failed to create spec version #{@spec_version.id}: " + @spec_version.errors.full_messages.join("\n")
        render :json => {:errors => @spec_version.errors.full_messages}, :status => :unprocessable_entity
      end
    end

    def update
      @spec_version = current_object
      if @spec_version.update_attributes(params[:spec_version_resource])
        render :json => @spec_version
      else
        logger.error "Failed to update display #{@spec_version.id}: " + @spec_version.errors.full_messages.join("\n")
        render :json => {:errors => @spec_version.errors.full_messages}, :status => :unprocessable_entity
      end
    end

    def destroy
      @spec_version = current_object
      @spec_version.destroy
      render :json => @spec_version
    end

    protected

    def model_class
      Doogle::SpecVersion
    end
    def model_name
      'spec_version'
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
        if spec_version_params = params[:spec_version_resource]
          id = spec_version_params.delete(:new_spec_version_id)
        end
        @current_object = Doogle::SpecVersion.new(spec_version_params)
        @current_object.id = id if id
      end
      @current_object
    end
  end
end
