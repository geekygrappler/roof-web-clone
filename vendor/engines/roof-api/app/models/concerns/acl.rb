module Acl
  extend ActiveSupport::Concern
  included do
    scope :accessible_through_project_by, ->(account) {
      joins(:project).where(["projects.account_id = ? OR projects.data->'customers_ids' @> ?", account.id, account.id.to_json])
    }
  end
end
