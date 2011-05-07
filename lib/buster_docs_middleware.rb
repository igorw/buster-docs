require "rack/static"
require "buster_docs_template"

class BusterDocsMiddleware
  def initialize(context_path = "")
    @context_path = context_path
    @views_root = File.expand_path(File.join(File.dirname(__FILE__), "/../views"))
    @docs_root = File.join(@views_root, "docs")

    @static = Rack::Static.new(proc{}, {
        :urls => ["/stylesheets", "/javascripts", "/favicon.ico", "/images"],
        :root => File.expand_path(File.dirname(__FILE__) + "/../public")
      })
  end

  def call(env)
    if env["PATH_INFO"][0...(@context_path.length)] != @context_path
      return not_found
    end

    env["buster-docs.path"] = env["PATH_INFO"][(@context_path.length)..-1]
    possible_doc = File.expand_path(File.join(@docs_root, env["buster-docs.path"]))

    # Don't go below the docs root directory
    if possible_doc !~ /^#{@docs_root}/
      puts "Aww"
      return not_found
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

    static_env = env.dup
    static_env["PATH_INFO"] = env["buster-docs.path"]
    @static.call(static_env)
  end

  def serve_template(path)
    template = BusterDocsTemplate.new(path, @views_root, @context_path)
    [200, {"Content-Type" => "text/html"}, StringIO.new(template.render)]
  end

  def not_found
    [404, {"Content-Type" => "text/plain"}, StringIO.new("")]
  end
end
