class DocumentsController < ApplicationController

    def new
        @default_sections = ["Preliminary", "Plumbing", "Electrics", "Carpentry", "Decorating", "Flooring", "General"]
        @document = Document.create(
            name: "This is a doc"
        )
        @default_sections.each do |section|
            @document.sections.create(name: section)
        end
        render json: @document
    end
end
