require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
    setup do
        @line_item = line_items(:one)
    end

    test "line item should belong to a master if it has the same name" do
        @response = post :create, line_item: {
            name: @line_item.name
        }
        @new_line_item = LineItem.find(JSON(@response.body)["id"])
        assert_equal(@new_line_item.line_item, @line_item)
    end

    test "line item should be orphan if it has a name not matching a master line item" do
        @response = post :create, line_item: {
            name: "A made up, original name"
        }
        @new_line_item = LineItem.find(JSON(@response.body)["id"])
        assert_nil(@new_line_item.line_item)
    end
end
