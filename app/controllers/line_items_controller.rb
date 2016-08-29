class LineItemsController < ApplicationController
    respond_to :json

    # POST /line_items
    # POST /line_items.json
    def create
        parent_line_item = LineItem.where(name: line_item_params["name"])
        @line_item = LineItem.create(line_item_params);
        @line_item.line_item = parent_line_item
    end

    private

    def line_item_params
        params.require(:lineItem).permit(:name)
    end
end
