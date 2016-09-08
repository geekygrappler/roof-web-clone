class SearchController < ApplicationController
  respond_to :json

  def line_items
    render json: {
        results:
            LineItem.full_text_search(params[:query])
                .map {|item| LineItemSearchSerializer.new(item)}
    }
  end

  def building_materials
    render json: {
        results:
            BuildingMaterial.full_text_search(params[:query])
                .map {|item| BuildingMaterialSearchSerializer.new(item)}
    }
  end
end
