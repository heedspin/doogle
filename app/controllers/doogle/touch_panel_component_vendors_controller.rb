class Doogle::TouchPanelComponentVendorsController < Doogle::DoogleController
  def index
    if (@search_term = params[:term]).present?
      # Autocomplete path.
      names = Doogle::SearchTouchPanelComponentVendors.name_like(@search_term)
      if names.size == 0
        names.push 'No Results'
      end
      render :json => names
    end
  end
end
