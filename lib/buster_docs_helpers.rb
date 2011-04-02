module BusterDocsHelpers
  def module_navigation
    <<-HTML
      <h2>Buster.<span>JS</span> modules</h2>
      #{module_list(docs_root)}
    HTML
  end

  def module_list(dir)
    return "" if !File.directory?(dir)
    modules = (Dir.entries(dir).entries.find_all { |d| /^\.\.?$/ !~ d }.collect do |m|
      m.sub(/\.html\.erb$/, "")
    end).uniq.sort

    return "" if modules.length == 0

    <<-HTML
      <ul class="nav">
        #{modules.collect { |mod| module_list_item(File.expand_path(File.join(dir, mod))) }.join("\n        ")}
      </ul>
    HTML
  end

  def module_list_item(path)
    <<-HTML
      <li#{' class="active"' if active?(path)}>
        <a href="#{module_url(path)}">#{module_title(path)}</a>
        #{module_list(path)}
      </li>
    HTML
  end

  def active?(mod)
    path =~ /\/#{File.basename(mod.sub(/\.html\.erb/, ''))}/
  end

  def module_url(path)
    path.sub(/^#{docs_root}/, "").sub(/\.html\.erb$/, "").gsub(/^\/*|\/*$/, "/")
  end

  def module_title(path)
    index = File.join(path, "index.html")
    title = nil

    if File.exists?(index)
      title = File.read(index).match(/h1>(.*)<\/h1/)[1]
    end

    title || File.basename(path).sub(/\.html\.erb$/, "")
  end

  def event(name, arguments = {})
    args = arguments.inject([]) do |args, kv|
      if kv[1] =~ /^#/
        args << anchor("<code>#{kv[0]}</code>", kv[1])
      else
        args << m(kv[1], "<code>#{kv[0]}</code>")
      end

      args
    end

    <<-HTML
        <h3 id="#{id('event-' + name)}" data-title="+#{name}+">
          Event: <code>"#{name}", function (#{args.join(', ')}) {}</code>
        </h3>
    HTML
  end

  def property(name, default)
    <<-HTML
        <h3 id="#{id(name)}" data-title="+#{name}+">
          <code>#{name}</code> (<code>#{default}</code>)
        </h3>
    HTML
  end

  def decamelize(name, sep = "-")
    name.split(/([A-Z])/).inject("") do |str, item|
      str += (item == item.upcase ? "#{sep}" : "") + item.downcase
    end
  end

  def id(name)
    "#{id_prefix}#{name.to_s.sub(/^#/, '').gsub(/[:\.]/, '-')}"
  end

  def ref(name)
    "##{id(name)}"
  end

  def anchor(text, target = nil)
    target ||= text
    "<a href=\"#{ref(target)}\">#{text}</a>"
  end

  # Link to a buster module
  # +name+ should be like "eventEmitter", will be presented as
  # "buster.eventEmitter"
  def m(name, display_name = nil)
    display_name ||= "<code>buster.#{name}</code>"
    url = module_url("buster-#{decamelize(name)}")

    if name =~ /.+#/
      pieces = name.split("#")
      url = module_url("buster-#{decamelize(pieces[0])}") + "##{pieces[1]}"
    end

    "<a href=\"#{url}\">#{display_name}</a>"
  end

  # Link to a ref
  def l(name)
    anchor("<code>#{name}</code>", name)
  end

  # Link to an event
  def e(name, display_name = nil)
    display_name ||= "<code>\"#{name}\"</code>"
    anchor(display_name, "event-#{name}")
  end
end
