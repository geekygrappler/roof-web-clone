class StagesController < ApplicationController
    respond_to :json
    before_action :set_section, only: [:show, :update, :destroy]


    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:update]

    def show
        render json: @stage
    end

    def create
        @stage = Stage.new(section_params)
        if @stage.save
            render json: @stage, status: :created, location: @stage
        else
            render json: @stage.errors, status: :unprocessable_entity
        end
    end

    def update
        @stage.assign_attributes(section_params)
        if @stage.save
            render json: @stage
        else
            render nothing: true, status: :bad_request
        end
    end

    def destroy
        @stage.destroy
        render json: @stage, status: :ok
    end

    private

    def set_section
        @stage = Stage.find(params[:id])
    end

    def section_params
        params.require(:stage).permit(:name, :notes, :document_id)
    end
end
