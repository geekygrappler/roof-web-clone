module Pagination

  extend ActiveSupport::Concern

  LIMIT = 50

  included do
    helper_method :current_page, :total_pages, :pager_start, :pager_end, :has_next_page?, :has_previous_page?, :paginated_records
  end

  def limit
    params[:limit] ? params[:limit].to_i : LIMIT
  end

  def offset
    params[:offset] ? params[:offset].to_i : (current_page - 1) * LIMIT
  end

  protected

  def paginated_records
    @records.offset(offset).limit(limit)
  end

  def current_page
    @current_page ||= params[:page] ? params[:page].to_i : 1
  end

  def total_pages
    @total_pages ||= (@records.count.to_f / limit.to_f).ceil
  end

  def pager_start limit
    [current_page - (limit / 2).floor, 1].max
  end

  def pager_end limit
    [current_page + (limit / 2).floor, total_pages].min
  end

  def has_previous_page? limit
    current_page - 1 > 0
  end

  def has_next_page? limit
    current_page < total_pages
  end

end
