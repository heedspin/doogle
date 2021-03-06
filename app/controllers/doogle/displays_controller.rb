require 'doogle_config'

class Doogle::DisplaysController < Doogle::DoogleController

  def index
    search_params = params[:search]
    @search = Doogle::Display.new(search_params)
    unless @search.status_option_id.present?
      @search.status_option_id = Doogle::StatusOption.draft_and_published.id
    end
    @search.type_key ||= 'any'
    if search_params
      @filter_fields = Set.new ; @filter_fields.add :model_number ; @filter_fields.add :display_type
      display_scope = Doogle::Display
      Doogle::FieldConfig.all.select { |f| f.searchable? and !f.composite? }.each do |field|
        if @search.search_field_specified?(field)
          # logger.info("Doogle Search Field #{field.key} specified. Scoping with #{field.search_scope_key}(#{@search.send(field.search_value_key).inspect})")
          @filter_fields.add field.composite_parent.key
          display_scope = @search.search_scope(display_scope, field)
        end
      end
      @displays = display_scope.by_model_number
    end
    respond_to do |f|
      f.html do
        if @displays
          @displays = display_scope.paginate(:page => params[:page], :per_page => 100)
          # Choose shown/hidden columns for results.
          @search_result_fields = @displays.map(&:display_type).uniq.map(&:fields).flatten.uniq
          @search_result_fields = @search_result_fields.select { |f| f.renderable? && ![:datasheet, :specification, :source_specification].include?(f.key) }
          @fields_to_show = @filter_fields.map { |k| Doogle::FieldConfig.for_key(k) }
        end
        if request.xhr?
          render :action => '_search_results', :layout => false
        else
          @show_search_fields = @search.display_type.try(:default_search_fields)
        end
      end
      f.xls do
        display_export = Doogle::DisplayExport.new(@search, @displays)
        headers['Content-Disposition'] = "attachment; filename=\"#{display_export.filename}.xls\""
        headers['Content-type'] = 'application/vnd.ms-excel'
        render :text => display_export.to_xls
      end
    end
  end

  def show
    @display = current_object
    @display_vendors = @display.latest_vendors.sort_by(&:last_date).reverse
    @display_logs = @display.logs.by_date_desc.log_type(Doogle::LogType.opportunity,Doogle::LogType.quote,Doogle::LogType.create,Doogle::LogType.spec,Doogle::LogType.vendor, Doogle::LogType.comment, Doogle::LogType.eol).limit(40)
  end
  
  def next_model_number
    if (display_type = Doogle::DisplayConfig.find_by_key(params[:display_type])) and (next_model_number = display_type.next_model_number)
      render :json => next_model_number
    else
      render :json => 'sorry failed'
    end
  end

  def new
    if rev_id = params[:rev]
      @revising = Doogle::Display.find(rev_id)
      @display = @revising.dup
      @display.previous_revision_id = rev_id
      @display.forget_attachments
      @display.interface_types = @revising.interface_types
      @display.model_number = @display.model_number.succ
      @display.errors.add(:model_number, "New Revision")
      @display.status = Doogle::Status.published
    else
      @display = build_object
      @display.status ||= Doogle::Status.draft
      @display.on_master_list = @display.publish_to_web = @display.publish_to_erp = false
    end
  end

  def edit
    @display = current_object
    @display.description ||= @display.default_description
  end

  def create
    @display = build_object
    if @display.save
      @display.sync_to_erp!
      @display.previous_revision.try(:destroy)
      @display.maybe_sync_to_web
      flash[:notice] = 'Display was successfully created.'
      if params[:commit] == 'Save & Edit'
        redirect_to(edit_doogle_display_url(@display, :return_to => params[:return_to]))
      else
        redirect_to doogle_display_url(@display)
      end
    else
      logger.info 'Failed to save display: ' + @display.errors.full_messages.join("\n")
      render :action => "new"
    end
  end

  def update
    @display = current_object

    if @display.update_attributes(params[:display])
      @display.sync_to_erp!
      @display.maybe_sync_to_web
      flash[:notice] = 'Display was successfully updated.'
      if params[:commit] == 'Save & Edit'
        redirect_to(edit_doogle_display_url(@display, :return_to => params[:return_to]))
      else
        redirect_to doogle_display_url(@display)
      end
    else
      render :action => "edit"
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
  
  def web_preview
    if (@key = params[:key]).present?
      @displays = Doogle::Display.display_type(@key).web.not_deleted.all
      @search = Doogle::Display.new(:type_key => @key)
    end
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
        @current_object.type_key ||= Doogle::DisplayConfig.all.first.key
      end
      @current_object
    end
end
