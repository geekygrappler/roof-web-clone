class SectionsController < ApplicationController
    before_filter :find_section, only: [:show, :update]

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:update]

    def show
        render json: @section
    end

    def update
        byebug
        puts params['section']
        @section.assign_attributes(section_params)
        if @section.save
            render json: @section
        else
            render nothing: true, status: :bad_request
        end
    end

    private

    def find_section
        @section = Section.find(params[:id])
    end

    def section_params
        params.require(:section).permit(:name, :notes)
    end
end
