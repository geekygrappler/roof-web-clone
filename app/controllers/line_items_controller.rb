class LineItemsController < ApplicationController
    before_action :set_line_item, only: [:update, :destroy]
    respond_to :json

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create, :update]

    # POST /line_items
    # POST /line_items.json
    def create
        @line_item = LineItem.new(line_item_params);

        if @line_item.save
            render json: @line_item, status: :created, location: @line_item
        else
            render nothing: true, status: :bad_request
        end
    end

    # PATCH /line_items/:id
    def update
        @line_item.assign_attributes(line_item_params)
        if params[:line_item][:item_action]
            @line_item.item_action = ItemAction.find(item_action_params[:id])
        end
        if params[:line_item][:item_spec]
            @line_item.item_spec = ItemSpec.find(item_spec_params[:id])
        end
        if params[:line_item][:location]
            @line_item.location = Location.find(location_params[:id])
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
        line_item_adapter
        params.require(:line_item).permit(:name, :section_id, :quantity, :description, :unit, :item_action, :item_spec, :rate, :total)
    end

    def item_action_params
        params.require(:line_item).require(:item_action).permit(:id, :name)
    end

    def item_spec_params
        params.require(:line_item).require(:item_spec).permit(:id, :name)
    end

    def location_params
        params.require(:line_item).require(:location).permit(:id, :name)
    end

    def set_line_item
        @line_item = LineItem.find(params[:id])
    end

    # Transform any incoming data to the correct format.
    # Currently deals with any incoming value for 'material_cost'
    def line_item_adapter
        clean_string_to_cents(params[:line_item], :rate)
        clean_string_to_cents(params[:line_item], :total)
    end

    def clean_string_to_cents(obj, key)
        obj[key] = Monetize.parse(obj[key]).cents if obj[key] && !is_number?(obj[key])
    end

    def is_number? string
        true if Float(string) rescue false
    end
end
