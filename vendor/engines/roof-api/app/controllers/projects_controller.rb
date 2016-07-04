class ProjectsController < ResourceController

  protected

  def permitted_attributes
    if current_account.try(:administrator?)
      [
        :kind,
        :name,
        {
          brief: [
            :description,
            :budget,
            :preferred_start,
            :ownership,
            :plans,
            :planning_permission,
            :structural_drawings,
            :party_wall_agreement
          ]
        },
        {address: [:street_address, :city, :postcode, :country]},
        {assets_attributes: [:id, :file, :_destroy]},
        :asset_ids,
        :account_id,
        {:customers_ids => []},
        {:professionals_ids => []},
        {:administrators_ids => []}
      ]
    else
    [
      :kind,
      :name,
      {
        brief: [
          :description,
          :budget,
          :preferred_start,
          :ownership,
          :plans,
          :planning_permission,
          :structural_drawings,
          :party_wall_agreement
        ]
      },
      {address: [:street_address, :city, :postcode, :country]},
      {assets_attributes: [:id, :file, :_destroy]},
      :asset_ids,
      :account_id
    ]
    end
  end

  def permitted_params
    super.tap{ |params|
      params[:account_id] = current_account.try(:administrator?) ? (params[:account_id] || current_account.try(:id)) : current_account.try(:id)
    }
  end

end
