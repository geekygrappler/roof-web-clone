class Item < ActiveRecord::Base
    include PgSearch

    belongs_to :action
    has_many :spec

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
