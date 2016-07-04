class AppointmentsController < ResourceController

  protected

  def set_records
    super
    @records = @records.where(project_id: params[:project_id]) if params[:project_id]
    @records = @records.where(id: params[:id]) if params[:id]
    @records
  end

  def permitted_attributes
    [
      :time, :description, :project_id, :host_id, :host_type, :attendant_id, :attendant_type
    ]
  end

end
