class SearchController < ApplicationController
  respond_to :json

  def line_items
    render json: {
        results:
            ActiveModel::Serializer::CollectionSerializer.new(
              LineItem.full_text_search(params[:query]),
              each_serializer: LineItemSerializer
          )
    }
  end
end
