class CommentsController < ResourceController

  protected

  def set_records
    super
    @records = @records.search(params[:query]) if params[:query]
    @records = @records.where(commentable_id: params[:commentable_id], commentable_type: params[:commentable_type]) if params[:commentable_id] && params[:commentable_type]
    @records = @records.where(commentable_parent_id: params[:commentable_parent_id], commentable_parent_type: params[:commentable_parent_type]) if params[:commentable_parent_id] && params[:commentable_parent_type]
    @records = @records.where(id: params[:id]) if params[:id]
    @records
  end

  def permitted_attributes
    [
      :text,
      :commentable_id,
      :commentable_type,
      :commentable_parent_id,
      :commentable_parent_type,
      :project_id,
      :account_id
    ]
  end

  def permitted_params
    super
    @permitted_params[:account_id] = current_account.id if current_account
    @permitted_params
  end
end
