class LineItemSearchSerializer < ActiveModel::Serializer
  attributes :id, :text
  def text
    object.pg_search_highlight
  end
end
