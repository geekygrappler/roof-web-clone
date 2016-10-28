class SpecsController < ApplicationController

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create]

    # GET /specs
    def index
        render json: Spec.all
    end

    # POST /specs
    def create
        item = Item.where(name: spec_params[:item_name]).first
        @spec = Spec.create(name: spec_params[:name], item: item)
        render nothing: true
    end

    private

    def spec_params
        # spec already taken by rails, should rename this model.
        params.require(:spec).permit(:name, :item_name)
    end
end
