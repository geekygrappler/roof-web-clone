require "rails_helper"

RSpec.describe LineItem, :type => :model do
  it "It calculates the total" do
    line_item = LineItem.create!(name: "Example", rate: 900, quantity: 1)
    expect(line_item.total).to eq(900)
  end
end