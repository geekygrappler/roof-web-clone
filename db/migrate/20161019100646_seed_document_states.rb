class SeedDocumentStates < ActiveRecord::Migration
    def up
        states = ["tender", "quote"]
        states.each do |state|
            DocumentState.create(name: state)
        end
    end

    def down
        DocumentState.delete_all
    end
end
