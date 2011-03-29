class BusterDocsTemplate < StringIO
  def initialize(path, docs_root)
    @context_path = ""
    @docs_root = File.expand_path(docs_root)
    @path = File.expand_path(path).sub(@docs_root, "")
    
    html = File.read(path).gsub(/\{\{([^\}]*)\}\}/) do |match|
      sym = match[2...-2].to_sym
      respond_to?(sym) ? send(sym) : ""
    end

    super(html)
  end

  def footer
    <<-HTML
    <div class="footer">
      <p>Buster uses <a href="http://semver.org/">Semantic versioning</a>.
        Copyright 2010 - 2011,
        <a href="http://augustl.com/">Augustl Lilleaase</a> and
        <a href="http://cjohansen.no/">Christian Johansen</a>. Released under the 
        <a href="http://www.opensource.org/licenses/bsd-license.php">BSD license</a>.
        Documentation released under
        <a href="http://creativecommons.org/licenses/by-sa/3.0/">CC Attribution-Share Alike</a>.
      </p>
    </div>
    HTML
  end

  def contextPath
    @context_path
  end

  def module_navigation
    modules = Dir.entries(@docs_root).entries.find_all do |d|
      /^\.\.?$/ !~ d && File.directory?(File.join(@docs_root, d))
    end

    <<-HTML
      <h2>Buster.<span>JS</span> modules</h2>
      #{module_list(@docs_root)}
    HTML
  end

  private
  def module_list(dir)
    modules = Dir.entries(dir).entries.find_all do |d|
      /^\.\.?$/ !~ d && File.directory?(File.join(dir, d))
    end

    return "" if modules.length == 0

    <<-HTML
      <ul class="nav">
        #{modules.collect { |mod| module_link(File.expand_path(File.join(dir, mod))) }.join("\n        ")}
      </ul>
    HTML
  end

  def module_link(path)
    mod = File.basename(path)
    active = @path =~ /^\/#{mod}/
    link = "<a href=\"/#{mod}/\">#{module_title(path)}</a>"
    nav = module_list(path)

    "<li#{' class="active"' if active}>#{link}#{nav}</li>"
  end

  def module_title(path)
    index = File.join(path, "index.html")
    title = nil

    if File.exists?(index)
      title = File.read(index).match(/h1>(.*)<\/h1/)[1]
    end

    title || File.basename(path)
  end
end
