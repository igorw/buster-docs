require "rack/static"
require "buster_docs_template"

class BusterDocsMiddleware
  def initialize
    @docs_root = File.dirname(__FILE__) + "/../docs"
  end
  
  def call(env)
    possible_doc = File.join(@docs_root, env["PATH_INFO"])
    
    if File.directory?(possible_doc) && File.file?(possible_doc + "/index.html")
      return serve_template(possible_doc + "/index.html")
    end

    if File.file?(possible_doc)
      return serve_template(possible_doc)
    end

    [404, {"Content-Type" => "text/plain"}, StringIO.new("")]
  end

  def serve_template(path)
    [200, {"Content-Type" => "text/html"}, BusterDocsTemplate.new(path, @docs_root)]
  end
end
