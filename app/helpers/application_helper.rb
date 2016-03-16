module ApplicationHelper
  include ActionView::Template::Handlers
  def render_page page
    body = page ? page.body : @fallback
    render_erb_body body
  end
  def render_erb_body body
    ERB.erb_implementation.new(body).result(binding).html_safe
  end
  def brief_path
    # current_account ? '/app/projects/new' : '/brief'
    '/app/projects/new'
  end
  def header
    page_header_exists = File.exists?("#{Rails.root}/app/views/pages/#{pathname}/_header.html.erb")
    page_header_exists ? "pages/#{pathname}/header" : 'shared/header'
  end
end
