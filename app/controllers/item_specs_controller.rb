class ItemSpecsController < ApplicationController

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create]

    # GET /specs
    def index
        render json: Spec.all
    end

    # POST /specs
    def create
        item = Item.where(name: item_params).last
        @item_spec = ItemSpec.find_or_create_by(name: item_spec_params[:name])
        @item_spec.item = item
        if @item_spec.save
            render json: @item_spec
        end
    end

    private

    def item_spec_params
        params.require(:item_spec).permit(:name)
    end

    def item_params
        params.require(:item_name)
    end
end
