class DocumentsController < ApplicationController
    before_action :set_document, only: [:show]

    # GET /document_states/1
    # GET /document_states/1.json
    def show
        render json: @document
    end

    # GET /documents/new
    def new
        default_sections = ["Preliminary", "Plumbing", "Electrics", "Carpentry", "Decorating", "Flooring", "General"]
        @document = Document.create(
            name: "Flat 44b Rennovation"
        )
        default_sections.each do |section|
            @document.sections.create(name: section, notes: "#{section} Notes")
        end
        redirect_to @document
    end

    private

    def set_document
        @document = Document.find(params[:id])
    end

    def document_params
        params.require(:document).permit(:name)
    end
end
