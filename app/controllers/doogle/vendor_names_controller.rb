class Doogle::VendorNamesController < Doogle::DoogleController
  def index
    @vendors = Doogle::DisplayPrice.uniq_vendor_names_like(params[:term])
    names = @vendors.map { |v| { :label => v, :value => v } }
    if names.size == 0
      names.push({:label => 'No Results', :value => 'No Results'})
    end
    render :json => names.to_json
  end

end
