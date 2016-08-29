require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
    setup do
        @list_item = line_items(:one )
    end

    test "line item should belong to a master if it has the same name" do
        @new_line_item = post :create, line_item: {
            name: @line_item.name
        }
        puts @new_line_item
    end
end
