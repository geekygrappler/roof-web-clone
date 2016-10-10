class DocumentsController < ApplicationController
    before_action :set_document, only: [:show]

    # GET /document_states/1
    # GET /document_states/1.json
    def show
        respond_to do |format|
            format.json { render json: @document, serializer: DocumentSerializer }
            format.html { @invite_path = invite_spec_path(document_id: @document.id) }
        end
    end

    # GET /documents/new
    def new
        master_document = Document.where(name: "Master Document").first
        @document = master_document.dup
        @document.name = "New tender"
        if @document.save
            master_document.sections.each do |section|
                new_section = section.dup
                new_section.document = @document
                if new_section.save
                    section.line_items.each do |line_item|
                        new_line_item = line_item.dup
                        new_line_item.section = new_section
                        new_line_item.save
                    end
                end
            end
        end
        # @document.user_id = current_user.id if current_user.present
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
