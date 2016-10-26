class SearchController < ApplicationController
    respond_to :json

    def line_items
        render json: {
            results:
            LineItem.where(searchable: true).full_text_search(params[:query])
            .map {|item| LineItemSearchSerializer.new(item)}
        }
    end

    def building_materials
        render json: {
            results:
            BuildingMaterial.where(searchable: true).full_text_search(params[:query])
            .map {|item| BuildingMaterialSearchSerializer.new(item)}
        }
    end

    def items
        if (params[:action_id])
            results = Item.full_text_search(params[:query])
            .select { |item| item.actions.exists?(params[:action_id]) }
            .map { |item| ItemSearchSerializer.new(item) }
        else
            results = Item.full_text_search(params[:query])
            .map { |item| ItemSearchSerializer.new(item) }
        end
        render json: {
            results: results
        }
    end

    def specs
        item = Item.where(name: params[:item_name]).first
        if item
            results = item.spec.map { |spec| {id: spec.id, name: spec.name} }
        else
            results = []
        end
        render json: {
            results: results
        }
    end

    def actions
        item = Item.where(name: params[:item_name]).first
        if item
            results = item.actions.map { |action| {id: action.id, name: action.name} }
        else
            results = []
        end
        render json: {
            results: results
        }
    end
end
