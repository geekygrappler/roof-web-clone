class PagesController < ApplicationController

  layout :determine_layout
  helper_method :pathname

  def show
    @page = Content::Page.find_by(pathname: pathname)
    @fallback = File.read("#{Rails.root}/app/views/pages/#{pathname}.html.erb") rescue nil
    redirect_to "/pages/404" and return if @page.nil? and @fallback.nil?
  end

  def app
    render layout: 'application'
  end

  private

  def determine_layout
    paths = pathname.split("/")
    template_exists = template_exists? paths.last, "layouts", false, [], { :formats => [:html],  :handlers => [:erb], :locale => [:en] }
    template_exists ? pathname : 'page'
  end

  def pathname
    params[:pathname] || params[:path] ||  "landing"
  end
end
