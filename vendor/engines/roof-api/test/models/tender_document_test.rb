require 'test_helper'

class TenderDocumentTest < ActiveSupport::TestCase
  setup do
    Task.delete_all
    @tender = tender_templates(:two)
  end
  test "calculates" do
    assert_equal 1448, @tender.document.total
    assert_equal 1240, @tender.document.subtotal
    assert_equal 208, @tender.document.vat
    assert_equal 1040, @tender.document.tasks_total
    assert_equal 200, @tender.document.materials_total
    assert_equal 600, @tender.document.section_total('Kitchen')
    assert_equal 4, @tender.document.new_items('tasks').size
  end
  test "created new items" do
    refute @tender.document.create_new_items('tasks').empty?
    assert @tender.document.new_items('tasks').empty?
  end
end
