class AssetsController < ResourceController

  skip_before_action :auth_xhr!, only: [:create]

  def create
    if params[:project_id]
      project = Project.find(params[:project_id])
      render nothing: true, :status => :forbidden and return unless (current_account.administrator? || project.member?(current_account))
      Asset.where({id: params[:ids]}).update_all({project_id: params[:project_id]})
      render json: {updated: true}, status: 200
    else
      super
    end
  end

  protected

  def permitted_attributes
    [:file, :project_id]
  end

  def set_records
    @records = super
    @records = @records.where(project_id: params[:project_id]) if params[:project_id]
    @records
  end

end
