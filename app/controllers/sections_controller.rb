class SectionsController < ApplicationController
    respond_to :json
    before_filter :find_section, only: [:show, :update, :destroy]


    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:update]

    def show
        render json: @section
    end

    def create
        @section = Section.new(section_params)
        if @section.notes.nil?
            @section.notes = "#{@section.name} notes"
        end
        if @section.save
            render json: @section, status: :created, location: @section
        else
            render json: @section.errors, status: :unprocessable_entity
        end
    end

    def update
        @section.assign_attributes(section_params)
        if @section.save
            render json: @section
        else
            render nothing: true, status: :bad_request
        end
    end

    def destroy
        @section.destroy
        render json: @section, status: :ok
    end

    private

    def find_section
        @section = Section.find(params[:id])
    end

    def section_params
        params.require(:section).permit(:name, :notes, :document_id)
    end
end
