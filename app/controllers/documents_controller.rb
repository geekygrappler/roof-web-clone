class DocumentsController < ApplicationController
    before_action :set_document, only: [:show, :update]

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:update]

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
        # Duplicate our master document
        master_document = Document.where(name: "Master Document").last
        @document = master_document.dup
        @document.name = "New tender"
        if @document.save
            # Copy each section in the master document and set the new section's
            # document to be our new document, @document.
            master_document.sections.each do |section|
                new_section = section.dup
                new_section.document = @document
                if new_section.save
                    section.line_items.each do |line_item|
                        new_line_item = line_item.dup
                        new_line_item.section = new_section
                        new_line_item.searchable = false
                        new_line_item.admin_verified = false
                        new_line_item.save
                    end
                end
            end
        end
        # @document.user_id = current_user.id if current_user.present
        redirect_to @document
    end

    def update
        @document.assign_attributes(document_params)
        if @document.save
            render json: @document
        else
            render nothing: true, status: :bad_request
        end
    end

    private

    def set_document
        @document = Document.find(params[:id])
    end

    def document_params
        params.require(:document).permit(:name)
    end
end
