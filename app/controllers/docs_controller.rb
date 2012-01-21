class DocsController < ApplicationController
  def show
    render :template => "docs/" + (params[:path] || "index")
  end
end
