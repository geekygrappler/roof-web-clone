# This migration comes from roof_api_engine (originally 20160406115541)
class AddCommentableParentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_parent_id, :integer
    add_column :comments, :commentable_parent_type, :string
  end
end
