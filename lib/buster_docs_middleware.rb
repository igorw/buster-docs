require "rack/static"
require "buster_docs_template"

class BusterDocsMiddleware
  def initialize
    @views_root = File.expand_path(File.join(File.dirname(__FILE__), "/../views"))
    @docs_root = File.join(@views_root, "docs")
  end

  def call(env)
    possible_doc = File.expand_path(File.join(@docs_root, env["PATH_INFO"]))

    # Don't go below the docs root directory
    if possible_doc !~ /^#{@docs_root}/
      puts "Aww"
      [404, {"Content-Type" => "text/plain"}, StringIO.new("")]
    end

    if File.file?("#{possible_doc.sub(/\.html?$/, '')}.html.erb")
      return serve_template("#{possible_doc.sub(/\.html?$/, '')}.html.erb")
    end

    index = File.join(possible_doc, "index.html.erb")

    if File.directory?(possible_doc) && File.file?(index)
      return serve_template(index)
    end

    if File.file?("#{possible_doc}.erb")
      return serve_template("#{possible_doc}.erb")
    end

    [404, {"Content-Type" => "text/plain"}, StringIO.new("")]
  end

  def serve_template(path)
    template = BusterDocsTemplate.new(path, @views_root)
    [200, {"Content-Type" => "text/html"}, StringIO.new(template.render)]
  end
end
