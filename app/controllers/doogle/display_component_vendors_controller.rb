class Doogle::DisplayComponentVendorsController < Doogle::DoogleController
  def index
    if (@search_term = params[:term]).present?
      # Autocomplete path.
      names = Doogle::SearchDisplayComponentVendors.name_like(@search_term).map { |n| { :label => n, :value => n } }
      if names.size == 0
        names.push({:label => 'No Results', :value => 'No Results'})
      end
      render :json => names.to_json
    end
  end
end
