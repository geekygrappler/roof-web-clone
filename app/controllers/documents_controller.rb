class DocumentsController < ApplicationController
    before_action :set_document, only: [:show]

    # GET /document_states/1
    # GET /document_states/1.json
    def show
        respond_to do |format|
            format.json { render json: DocumentSerializer.new(@document).to_json }
            format.html { @document = DocumentSerializer.new(@document) }
        end
    end

    # GET /documents/new
    def new
        default_sections = ["Preliminary", "Plumbing", "Electrics", "Carpentry", "Decorating", "Flooring", "General"]
        @document = Document.create(
            name: "Name your project..."
        )
        default_sections.each do |section|
            @document.sections.create(name: section, notes: "#{section} Notes")
        end
        # @document.user_id = current_user.id if current_user.present?
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
