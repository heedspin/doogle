class Doogle::Displays::PricesController < Doogle::DoogleController
  filter_access_to :all, :context => :doogle_display_prices
  def index
    @display = parent_object
    @prices = @display.prices.by_start_date_desc.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @display = parent_object
    @price = build_object
  end
  
  def create
    @display = parent_object
    @price = build_object
    if @price.save
      redirect_to doogle_display_prices_url(@display)
    else
      render :action => 'new'
    end
  end

  def edit
    @display = parent_object
    @price = current_object
  end
  
  def update
    @display = parent_object
    @price = current_object
    if @price.update_attributes(params[model_name])
      redirect_to doogle_display_prices_url(@display)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @display = parent_object
    @price = current_object
    @price.destroy
    respond_to do |format|
      destination = doogle_display_prices_url(@display)
      format.html {
        flash[:notice] = "Pricing Deleted"
        redirect_to destination
      }
      format.js {
        render :json => { :location => destination }.to_json
      }
    end
  end

  protected
  
    def model_name
      :doogle_display_price
    end
    
    def current_object
      @current_object ||= Doogle::DisplayPrice.find(params[:id])
    end

    def parent_object
      @parent_object ||= Doogle::Display.find(params[:display_id])
    end
    
    def build_object
      @current_object ||= parent_object.prices.build(params[model_name])
    end

end
