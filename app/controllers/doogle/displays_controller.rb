require 'doogle_config'

class Doogle::DisplaysController < Doogle::DoogleController
  def index
    # Doogle::DisplayConfig.all
    search_params = params[:search]
    @search = Doogle::Display.new(search_params)
    unless @search.status_option_id.present?
      @search.status_option_id = Doogle::StatusOption.draft_and_published.id
    end
    # Rails.logger.debug "Search params: #{search_params.inspect}\nSearch object: #{@search.inspect}"
    if search_params
      @field_keys = Set.new ; @field_keys.add :model_number ; @field_keys.add :type
      display_scope = Doogle::Display
      Doogle::FieldConfig.all.select { |f| f.searchable? and !f.composite? }.each do |field|
        value_key = field.search_key
        value = @search.send(value_key)
        if value.present? or value.is_a?(FalseClass)
          @field_keys.add field.composite_parent.key
          # Rails.logger.debug "Scoping #{value_key} to #{value.to_s}"
          display_scope = display_scope.send(value_key, value)
        # elsif field.status?
        #          @field_keys.add field.composite_parent.key
        #          display_scope = display_scope.not_deleted
        end
      end
      @displays = display_scope.by_model_number.paginate(:page => params[:page], :per_page => 50)
      @fields = Doogle::FieldConfig.top_level.select { |f| @field_keys.member?(f.key) }
    end
    if request.xhr?
      render :action => '_search_results', :layout => false
    end
  end

  def show
    @display = current_object
  end
  
  def next_model_number
    if (display_type = Doogle::DisplayConfig.find_by_key(params[:display_type])) and (next_model_number = display_type.next_model_number)
      render :json => next_model_number
    else
      render :json => 'sorry failed'
    end
  end

  def new
    if dup_id = params[:dup]
      source = Doogle::Display.find(dup_id)
      @display = source.dup
      @display.forget_attachments
      @display.interface_types = source.interface_types
      @display.model_number = @display.model_number.succ
      @display.errors.add(:model_number, "New revision of #{source.model_number}")
    else
      @display = build_object
      @display.status ||= Doogle::Status.draft
      @display.publish_to_web = @display.publish_to_erp = true
    end
  end

  def edit
    @display = current_object
    @display.description ||= @display.display_type.name
  end

  def create
    @display = build_object
    if @display.save
      @display.sync_to_erp
      @display.maybe_sync_to_web
      flash[:notice] = 'Display was successfully created.'
      if params[:commit] == 'Save & Edit'
        redirect_to(edit_doogle_display_url(@display, :return_to => params[:return_to]))
      else
        redirect_to doogle_display_url(@display)
      end
    else
      render :action => "new"
    end
  end

  def update
    @display = current_object

    respond_to do |format|

      if (display_params = params[:display]) and (type = display_params.delete(:type))
        @display.type = type
      end
      if @display.update_attributes(display_params)
        @display.sync_to_erp
        @display.maybe_sync_to_web
        flash[:notice] = 'Display was successfully updated.'
        format.html {
          if params[:commit] == 'Save & Edit'
            redirect_to(edit_doogle_display_url(@display, :return_to => params[:return_to]))
          else
            redirect_to doogle_display_url(@display)
          end
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @display = current_object
    @display.destroy
    @display.maybe_sync_to_web
    respond_to do |format|
      format.html { redirect_to(doogle_displays_url) }
    end
  end

  def datasheet
    redirect_to request.host + '/' + params[:id]
  end

  protected

    def model_class
      Display
    end

    helper_method :name
    def name(key)
      Doogle::Display.human_attribute_name(key)
    end

    def current_object
      if @current_object.nil?
        if params[:id].to_i.to_s == params[:id].to_s
          @current_object = Doogle::Display.find(params[:id])
        else
          @current_object = Doogle::Display.find_by_model_number(params[:id]) || (raise ActiveRecord::RecordNotFound)
        end
        @current_object.current_user = current_user
      end
      @current_object
    end

    def build_object
      if @current_object.nil?
        @current_object = Doogle::Display.new(params[:display])
        @current_object.current_user = current_user
      end
      @current_object
    end
end
