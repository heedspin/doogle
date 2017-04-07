class Doogle::SpecVersionResourcesController < ApplicationController
  include ActionController::MimeResponds

if Rails::VERSION::MAJOR < 5
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token
else
  skip_before_action :verify_authenticity_token
end

  def show
    @spec_version = Doogle::SpecVersion.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => @spec_version.to_json
      end
    end
  end

  def create
    params.require(:spec_version_resource).permit!
    id = nil
    if spec_version_params = params[:spec_version_resource]
      id = spec_version_params.delete(:new_spec_version_id)
    end
    @spec_version = Doogle::SpecVersion.new(spec_version_params)
    @spec_version.id = id if id
    if @spec_version.save
      render :json => @spec_version
    else
      logger.error "Failed to create spec version #{@spec_version.id}: " + @spec_version.errors.full_messages.join("\n")
      render :json => {:errors => @spec_version.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def update
    params.require(:spec_version_resource).permit!
    @spec_version = Doogle::SpecVersion.find(params[:id])
    if @spec_version.update_attributes(params[:spec_version_resource])
      render :json => @spec_version
    else
      logger.error "Failed to update display #{@spec_version.id}: " + @spec_version.errors.full_messages.join("\n")
      render :json => {:errors => @spec_version.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    @spec_version = Doogle::SpecVersion.find(params[:id])
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

if Rails::VERSION::MAJOR < 5
  before_filter :require_api_key
else
  before_action :require_api_key
end
  def require_api_key
    unless (params[:api_key] == AppConfig.doogle_api_key)
      render :json => {}, :status => 403
    end
    true
  end
end
