class ItemActionsController < ApplicationController

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create]

    # GET /actions
    def index
        render json: ItemAction.all
    end

    # POST /actions
    # We always require an Item for an action to be associated to, no floating actions.
    def create
        item = Item.where(name: item_params).last
        @item_action = ItemAction.find_or_create_by(name: item_action_params[:name])
        item.item_actions << @item_action
        render json: @item_action
    end

    private

    def item_action_params
        # action already taken by rails, should rename this model.
        params.require(:item_action).permit(:name)
    end

    def item_params
        params.require(:item_name)
    end
end