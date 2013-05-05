require 'menu_selected'

class DisplayAssetsController < ApplicationController
  include MenuSelected
  skip_before_filter :require_login

  # before_filter :maybe_require_login, :only => :show
  # def maybe_require_login
  #   if request.env['HTTP_USER_AGENT'].include?('Excel')
  #     true
  #   else
  #     true #require_login
  #   end
  # end
  # 
  def show
    # logger.info request.env.select {|k,v| k.match("^HTTP.*")}.inspect
    # logger.info request.env.select {|k,v| k.match(".*requested.*")}.inspect
    if request.env['HTTP_USER_AGENT'].include?('Excel')
      # Convince Excel it's ok to send request to external browser (which must authenticate).
      render :text => 'hello excel', :status => 200
    else
      @display = current_object
      asset = params[:asset] || :datasheet
      version = params[:version]
      # Basic security check; make sure it's at least a field.
      if Doogle::FieldConfig.for_key(asset).nil?
        not_found
      else
        spec = if version
          @display.spec_versions.version(version).first
        else
          @display.spec_versions.latest.first
        end
        if spec.nil?
          not_found
        else
          asset_is_public = spec.asset_public?(asset)
          if asset_is_public or permitted_to?("read_#{asset}", :doogle_displays)
            if attachment = spec.send(asset)
              redirect_to attachment.expiring_url(300), :status => 307
            else
              not_found
            end
          else
            not_authorized
          end
        end
      end
    end
  end

  skip_before_filter :require_login, :only => [:options]
  def options
    logger.info request.env.select {|k,v| k.match("^HTTP.*")}.inspect
    logger.info request.env.select {|k,v| k.match(".*requested.*")}.inspect
    headers['Access-Control-Allow-Methods'] = 'GET,HEAD,OPTIONS'
    head :ok
  end

  protected

    def not_found
      render :template => "errors/404", :status => 404
    end

    def not_authorized
      render :template => "errors/403", :status => 403
    end

    def current_object
      if @current_object.nil?
        if params[:id].to_i.to_s == params[:id].to_s
          @current_object = Doogle::Display.find(params[:id])
        else
          @current_object = Doogle::Display.find_by_model_number(params[:id]) || (raise ActiveRecord::RecordNotFound)
        end
      end
      @current_object
    end
end
