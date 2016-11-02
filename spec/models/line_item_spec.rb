require "rails_helper"

RSpec.describe LineItem, :type => :model do
    pending "It calculates the total" do
        line_item = LineItem.create!(name: "Example", rate: 900, quantity: 2)
        expect(line_item.total).to eq(2000)
    end

    context "with Item" do

        pending "should never have no item_action or item_spec" do
            line_item = LineItem.create(name: "Example")
            expect(line_item.item_action).not_to be_nil
            expect(line_item.item_spec).not_to be_nil
        end
    end
end
