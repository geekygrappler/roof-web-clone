class SearchController < ApplicationController
  respond_to :json

  def line_items
    render json: {
        results:
            LineItem.full_text_search(params[:query])
                .with_pg_search_highlight.map {|item| LineItemSearchSerializer.new(item)}
    }
  end
end
