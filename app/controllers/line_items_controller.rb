class LineItemsController < ApplicationController
    respond_to :json

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create]

    # POST /line_items
    # POST /line_items.json
    def create
        parent_line_item = LineItem.where(name: line_item_params["name"]).first
        @line_item = LineItem.new(line_item_params);
        @line_item.line_item = parent_line_item
        if @line_item.save
            render json: @line_item, location: @line_item
        else
            render nothing: true, status: :bad_request
        end
    end

    private

    def line_item_params
        params.require(:line_item).permit(:name, :section_id)
    end
end
