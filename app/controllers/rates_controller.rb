# Could be powerful, allowing editing of Item, ItemAction & ItemSpec :-S
class RatesController < ApplicationController
    before_action :set_rate, only: [:edit, :update]

    # GET /rates.html
    def index
        @rates = Rate.all
        respond_to do |format|
            format.html { @rates }
        end
    end

    # GET /rates/new.html
    def new
        @rate = Rate.new
    end

    # POST /rates.html
    def create

    end

    # PATCH /rates/:id/edit
    def edit
        @rate
    end

    # PATCH /rates/:id
    def update
        @rate.assign_attributes(rate_params)
        if @rate.save
            redirect_to proc { edit_rate_path(@rate) }
        end
    end

    private
    def rate_params
        params.require(:rate).permit(:id, :rate)
    end

    def set_rate
        @rate = Rate.find(params[:id])
    end
end
