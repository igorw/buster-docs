require "erubis"
require "buster_docs_helpers"

class BusterDocsTemplate
  include BusterDocsHelpers
  attr_reader :context_path, :docs_root, :id_prefix, :path

  def initialize(path, views_root, context_path)
    @context_path = context_path
    @id_prefix = ""
    @views_root = File.expand_path(views_root)
    @docs_root = File.join(@views_root, "docs")
    @path = File.expand_path(path).sub(@docs_root, "")
  end

  def render
    render_template(File.join(@docs_root, @path))
  end

  def partial(file, opt = {})
    render_template(File.join(@views_root, "partials", "#{file}.html.erb"), opt)
  end

  private
  def render_template(file, opt = {})
    ctx = binding
    opt.each { |k, v| ctx.eval("#{k} = #{v.inspect}") }
    Erubis::Eruby.new(File.read(file)).result(ctx)
  end
end
