class MaterialsController < ResourceController

  protected

  def set_records
    super
    @records = @records.is_searchable unless current_account.try(:administrator?)
    @records = @records.search(params[:query]) if params[:query]
    @records = @records.where(id: params[:id]) if params[:id]
    @records
  end

  def permitted_attributes
    [
      :name,
      :quantity,
      :price,
      :supplied,
      :searchable,
      :tags
    ]
  end
end
