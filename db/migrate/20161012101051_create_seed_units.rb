class CreateSeedUnits < ActiveRecord::Migration
    def up
        units = [
            {
                name: "m",
                description: "linear meters",
                abbreviation: "m"
            },
            {
                name: "m2",
                description: "meters squared",
                abbreviation: "m",
                power: 2
            }
        ]
        units.each do |unit|
            Unit.create(name: unit[:name], description: unit[:description],
                abbreviation: unit[:abbreviation], power: unit[:power])
        end
    end

    def down
        Unit.delete_all
    end
end
