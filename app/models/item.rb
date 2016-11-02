class Item < ActiveRecord::Base
    include PgSearch

    has_and_belongs_to_many :item_actions
    has_many :item_specs

    pg_search_scope(
        :full_text_search,
        against: :name,
        using: {
            tsearch: {
                :any_word => true,
                :dictionary => 'english',
                :prefix => true,
                :highlight => true
            }
        }
    )
end
