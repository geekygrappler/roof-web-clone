class LineItemsController < ApplicationController
    before_action :set_line_item, only: [:update, :destroy]
    before_action :line_item_adapter, only: [:update]
    respond_to :json

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create, :update]

    # POST /line_items
    # POST /line_items.json
    def create
        parent_line_item = get_parent_line_item
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
        # We could be submitting a new parent line item, we want to change this line_item
        # to be a duplicate of the new parent
        new_parent_line_item = get_parent_line_item
        if new_parent_line_item
            @line_item.name = new_parent_line_item.name
            @line_item.line_item = new_parent_line_item
            @line_item.rate = new_parent_line_item.rate
        else
            # In a case where we're not changing the parent line item, simply
            # assign attributes
            @line_item.assign_attributes(line_item_params)
        end
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
        params.require(:line_item).permit(:name, :section_id, :quantity, :description, :material_cost)
    end

    def set_line_item
        @line_item = LineItem.find(params[:id])
    end

    # Transform any incoming data to the correct format.
    # Currently deals with any incoming value for 'material_cost'
    def line_item_adapter
        if params[:line_item][:material_cost]
            params[:line_item][:material_cost] = Monetize.parse(params[:line_item][:material_cost], "GBP").cents
        end
    end

    def get_parent_line_item
        if line_item_params[:name]
            LineItem.where(name: line_item_params["name"], searchable: true).first
        end
    end
end
