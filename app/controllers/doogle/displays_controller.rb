class Doogle::DisplaysController < ApplicationController
  filter_access_to :all

  def index
    search_params = params[:search]
    @search = Display::DisplaySearch.new(search_params)
    if search_params
      @displays = @search.filter(Display.not_deleted.by_resolution).paginate(:page => params[:page], :per_page => 50)
    end
    if request.xhr?
      render :action => '_search_results', :layout => false
    end
  end

  def show
    @display = current_object
    respond_to do |format|
      format.html# { redirect_to root_url }
      format.pdf  { redirect_to URI.encode(@display.datasheet.url), :status => 307 }
    end
  end

  def new
    @display = build_object
  end

  def edit
    @display = current_object
  end

  def create
    @display = build_object

    if @display.save
      flash[:notice] = 'Display was successfully created.'
      if params[:commit] == 'Save & Edit'
        redirect_to(edit_display_url(@display, :return_to => params[:return_to]))
      else
        redirect_back_or_default(display_url(@display))
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
        flash[:notice] = 'Display was successfully updated.'
        format.html {
          if params[:commit] == 'Save & Edit'
            redirect_to(edit_display_url(@display, :return_to => params[:return_to]))
          else
            redirect_back_or_default(display_url(@display))
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

    respond_to do |format|
      format.html { redirect_to(displays_url) }
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
      Display.human_attribute_name(key)
    end

    def current_object
      if @current_object.nil?
        if params[:id].to_i.to_s == params[:id].to_s
          @current_object = Display.find(params[:id])
        else
          @current_object = Display.find_by_model_number(params[:id]) || (raise ActiveRecord::RecordNotFound)
        end
      end
      @current_object
    end

    def build_object
      if @current_object.nil?
        display_params = params[:display]
        if display_params
          type = display_params.delete(:type)
        end
        @current_object = Display.new(display_params)
        if type
          @current_object.write_attribute(:type, type)
        end
      end
      @current_object
    end
end
