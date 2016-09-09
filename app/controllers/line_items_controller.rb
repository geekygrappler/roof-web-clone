class LineItemsController < ApplicationController
    before_action :set_line_item, only: [:update, :destroy]
    respond_to :json

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create, :update]

    # POST /line_items
    # POST /line_items.json
    def create
        parent_line_item = LineItem.where(name: line_item_params["name"], searchable: true).first
        if parent_line_item
            @line_item = parent_line_item.dup
            @line_item.line_item = parent_line_item
            @line_item.searchable = false
            @line_item.admin_verified = false
            @line_item.section_id = line_item_params["section_id"]
        else
            @line_item = LineItem.new(line_item_params);
        end

        if @line_item.save
            render json: @line_item, status: :created, location: @line_item
        else
            render nothing: true, status: :bad_request
        end
    end

    # PATCH /line_items/:id
    def update
        @line_item.assign_attributes(line_item_params)
        if @line_item.save
            render json: @line_item, status: :ok, location: @line_item
        else
            render json: @line_item.errors, status: :unprocessable_entity
        end
    end

    # DELETE /line_items/:id
    def destroy
        @line_item.destroy
        render json: @line_item, status: :ok
    end
    private

    def line_item_params
        params.require(:line_item).permit(:name, :section_id, :quantity, :description)
    end

    def set_line_item
        @line_item = LineItem.find(params[:id])
    end
end