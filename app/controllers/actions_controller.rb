class ActionsController < ApplicationController

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:create]

    # GET /actions
    def index
        render json: Action.all
    end

    # POST /actions
    def create
        item = Item.where(name: action_params[:item_name]).first
        @action = Action.new(name: action_params[:name])
        item.actions << @action
        render nothing: true
    end

    private

    def action_params
        # action already taken by rails, should rename this model.
        params.require(:xaction).permit(:name, :item_name)
    end
end
