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
        if (params[:item_action_id])
            results = Item.full_text_search(params[:query])
            .select { |item| item.item_actions.exists?(params[:item_action_id]) }
            .map { |item| ItemSearchSerializer.new(item) }
        else
            results = Item.full_text_search(params[:query])
            .map { |item| ItemSearchSerializer.new(item) }
        end
        render json: {
            results: results
        }
    end

    def item_specs
        item = Item.where(name: params[:item_name]).last
        if item
            results = item.item_specs.map { |spec| {id: spec.id, name: spec.name} }
        else
            results = []
        end
        render json: {
            results: results
        }
    end

    def item_actions
        item = Item.where(name: params[:item_name]).last
        if item
            results = item.item_actions.map { |action| {id: action.id, name: action.name} }
        else
            results = []
        end
        render json: {
            results: results
        }
    end
end
