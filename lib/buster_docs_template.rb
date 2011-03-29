require "erubis"
require "buster_docs_helpers"

class BusterDocsTemplate
  include BusterDocsHelpers
  attr_reader :context_path, :docs_root, :id_prefix

  def initialize(path, views_root)
    @context_path = ""
    @id_prefix = ""
    @views_root = File.expand_path(views_root)
    @docs_root = File.join(@views_root, "docs")
    @path = File.expand_path(path).sub(@docs_root, "")
  end

  def render
    render_template(File.join(@docs_root, @path))
  end

  def partial(file)
    render_template(File.join(@views_root, "partials", "#{file}.erb.html"))
  end

  private
  def render_template(file)
    Erubis::Eruby.new(File.read(file)).result(binding)
  end
end
