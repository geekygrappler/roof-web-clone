class DocumentsController < ApplicationController

    def new
        default_sections = ["Preliminary", "Plumbing", "Electrics", "Carpentry", "Decorating", "Flooring", "General"]
        @document = Document.create(
            name: "Flat 44b Rennovation"
        )
        default_sections.each do |section|
            @document.sections.create(name: section, notes: "#{section} Notes")
        end
        @document = ::DocumentSerializer.new(@document)
    end
end
