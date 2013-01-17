class Doogle::Displays::VendorCostsController < Doogle::DoogleController
  filter_access_to :all, :context => :doogle_display_vendor_costs
  def index
    @display = parent_object
    @vendor_costs = @display.vendor_costs.by_start_date_desc.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @display = parent_object
    @vendor_cost = build_object
  end
  
  def create
    @display = parent_object
    @vendor_cost = build_object
    if @vendor_cost.save
      redirect_to doogle_display_vendor_costs_url(@display)
    else
      render :action => 'new'
    end
  end

  def edit
    @display = parent_object
    @vendor_cost = current_object
  end
  
  def update
    @display = parent_object
    @vendor_cost = current_object
    if @vendor_cost.update_attributes(params[model_name])
      redirect_to doogle_display_vendor_costs_url(@display)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @display = parent_object
    @vendor_cost = current_object
    @vendor_cost.destroy
    respond_to do |format|
      destination = doogle_display_vendor_costs_url(@display)
      format.html {
        flash[:notice] = "Vendor Cost Deleted"
        redirect_to destination
      }
      format.js {
        render :json => { :location => destination }.to_json
      }
    end
  end

  protected
  
    def model_name
      :doogle_display_vendor_cost
    end
    
    def current_object
      @current_object ||= Doogle::DisplayVendorCost.find(params[:id])
    end

    def parent_object
      @parent_object ||= Doogle::Display.find(params[:display_id])
    end
    
    def build_object
      @current_object ||= parent_object.vendor_costs.build(params[model_name])
    end

end
