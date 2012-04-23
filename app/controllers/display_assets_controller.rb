class DisplayAssetsController < ApplicationController
  def show
    @display = current_object
    asset = params[:asset] || :datasheet
    # Basic security check; make sure it's at least a field.
    if Doogle::FieldConfig.for_key(asset).nil?
      not_found
    else
      asset_is_public = @display.asset_public?(asset)
      if asset_is_public or permitted_to?(:manage, :doogle_displays)
        if attachment = @display.send(asset)
          redirect_to attachment.expiring_url(60), :status => 307
        else
          not_found
        end
      else
        not_authorized
      end
    end
  end

  protected

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
