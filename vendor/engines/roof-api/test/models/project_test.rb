require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "has brief and validates it (aka composable)" do
    project = Project.new
    refute project.valid?
    assert project.errors.messages.keys.include?(:'brief.description')
  end
  test "has auto gen name from it's kind" do
    kind = Project.kinds.sample
    project = valid_customer_account.projects.create(kind: kind, brief: {description: 'yolo'})
    assert_equal "My #{kind.titleize} Project", project.name
  end
  test "has membership groups" do
    pro = accounts(:acc_pro)
    project = valid_customer_account.projects.create(kind: Project.kinds.first, brief: {description: 'yolo'})
    # creator account becomes auto member of his user_type
    assert project.customers.include?(valid_customer_account)
    assert project.customers_ids.include?(valid_customer_account.id)
    # membership methods
    assert project.customers_member?(valid_customer_account)
    assert project.member?(valid_customer_account)
    # new members
    project.add_to_professionals pro, true
    assert project.professionals_member?(pro)
    assert project.member?(pro)
    assert project.professionals_ids.include?(pro.id)
    # members has type validated
    project.add_to_customers accounts(:acc_pro)
    refute project.save
  end
  test "has assets" do
    project = projects(:one)
    project.update(asset_ids: [assets(:one).id])
    assert project.reload.assets.any?
  end
end
