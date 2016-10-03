require "rails_helper"

RSpec.describe LineItem, :type => :model do
  it "It calculates the total" do
    line_item = LineItem.create!(name: "Example", rate: 900, quantity: 2, material_cost: 100)
    expect(line_item.total).to eq(2000)
  end
end
