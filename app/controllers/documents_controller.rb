class DocumentsController < ApplicationController
    before_action :set_document, only: [:show, :update]

    #TODO remove this
    skip_before_filter :verify_authenticity_token, only: [:update]

    # GET /document_states/1
    # GET /document_states/1.json
    def show
        respond_to do |format|
            format.json { render json: @document }
            # We want to return a serialized version of the Document for React Component
            format.html { @document = DocumentSerializer.new(@document) }
        end
    end

    # GET /documents/new
    def new
        # Duplicate our master document
        master_document = Document.where(name: "Master Document").last
        @document = master_document.dup
        @document.name = "New tender"
        if @document.save
            master_document.stages.each do |stage|
                new_stage = stage.dup
                new_stage.document = @document
                @document.stages << new_stage
            end
            master_document.locations.each do |location|
                new_location = location.dup
                new_location.document = @document
                @document.locations << new_location
            end
            master_document.line_items.each do |line_item|
                new_line_item = line_item.dup
                new_line_item.document = @document
                new_line_item.save
            end
            redirect_to @document
        end
        # @document.user_id = current_user.id if current_user.present
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
