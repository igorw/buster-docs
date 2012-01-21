class DocsController < ApplicationController
  def show
    html = render_to_string :template => "docs/" + (params[:path] || "index"), :layout => false
    lines = html.split("\n")
    header = lines[0]

    if header.start_with?("<")
      @title = "Documentation"
    else
      @title = header
      html = "<h1>#{header}</h1>" + lines[1..-1].join("\n")
    end

    render :text => html, :layout => true
  end
end
