require "buster_js_docs/page"

class DocsController < ApplicationController
  def show
    template = render_to_string :template => "docs/" + (params[:path] || "index"), :layout => false
    page = BusterJsDocs::Page.new(template)
    page.parse
    render :text => page.html, :layout => true
  end
end
