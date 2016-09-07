class BuildingMaterialsController < ApplicationController
    before_action :set_building_material, only: [:update]
    respond_to :json

    # POST /building_materials
    # POST /building_materials.json
    def create
        parent_building_material = BuildingMaterial.where(name: building_material_params["name"]).first
        if parent_building_material
            @building_material = parent_building_material.dup
            @building_material.building_material = parent_building_material
            @building_material.section_id = building_material_params["section_id"]
        else
            @building_material = BuildingMaterial.new(building_material_params);
        end

        if @building_material.save
            render json: @building_material, status: :created, location: @building_material
        else
            render nothing: true, status: :bad_request
        end
    end

    # PATCH /building_materials/:id
    def update
        @building_material.assign_attributes(building_material_params)
        if @building_material.save
            render json: @building_material, status: :ok, location: @building_material
        else
            render json: @building_material.errors, status: :unprocessable_entity
        end
    end

    private

    def building_material_params
        params.require(:building_material).permit(:name, :section_id, :description, :supplied, :price)
    end

    def set_building_material
        @building_material = BuildingMaterial.find(params[:id])
    end
end
