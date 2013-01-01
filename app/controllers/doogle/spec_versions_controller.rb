class Doogle::SpecVersionsController < Doogle::DoogleController
  filter_access_to :all

  def index
    @display = parent_object
    @spec_versions = @display.spec_versions.by_version_desc.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @display = parent_object
    @spec_version = build_object
  end
  
  def create
    @display = parent_object
    @spec_version = build_object
    @spec_version.updated_by = current_user
    if @spec_version.save
      redirect_to doogle_display_spec_versions_url(@display)
    else
      render :action => 'new'
    end
  end

  def edit
    @display = parent_object
    @spec_version = current_object
  end
  
  def update
    @display = parent_object
    @spec_version = current_object
    @spec_version.updated_by = current_user
    if @spec_version.update_attributes(params[model_name])
      redirect_to doogle_display_spec_versions_url(@display)
    else
      render :action => 'edit'
    end
  end

  protected
  
    def model_name
      :spec_version
    end
    
    def current_object
      @current_object ||= Doogle::SpecVersion.find(params[:id])
    end

    def parent_object
      @parent_object ||= Doogle::Display.find(params[:display_id])
    end
    
    def build_object
      @current_object ||= parent_object.spec_versions.build(params[model_name])
    end

end
