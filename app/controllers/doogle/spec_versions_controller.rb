class Doogle::SpecVersionsController < Doogle::DoogleController
  filter_access_to :all, :context => :doogle_spec_versions
  def index
    @spec_versions = Doogle::SpecVersion.by_version_desc.paginate(:page => params[:page], :per_page => 20)
  end
  
  def show
    @spec_version = current_object
  end

  protected
  
    def model_name
      :spec_version
    end
    
    def current_object
      @current_object ||= Doogle::SpecVersion.find(params[:id])
    end

end
