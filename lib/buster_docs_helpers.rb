module BusterDocsHelpers
  def module_navigation
    modules = Dir.entries(docs_root).entries.find_all do |d|
      /^\.\.?$/ !~ d && File.directory?(File.join(docs_root, d))
    end

    <<-HTML
      <h2>Buster.<span>JS</span> modules</h2>
      #{module_list(docs_root)}
    HTML
  end

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

  def event(name, arguments = {})
    args = arguments.inject([]) do |sum, kv|
      if kv[1].nil?
        sum << kv[0]
      elsif kv[1] =~ /^#/
        sum << l(:bare, kv[0], id_hash(kv[1][1..-1]))
      else
        sum << l(:bare, kv[0], kv[1])
      end

      sum
    end

    <<-HTML
        <h3 id="event-#{id_hash(name)}" data-title="+#{name}+">
          Event: <code>"#{name}", function (#{args.join(', ')}) {}</code>
        </h3>
    HTML
  end

  def property(name, default)
    id = name.split(/([A-Z])/).inject("") do |str, item|
      str += (item == item.upcase ? "-" : "") + item.downcase
    end

    <<-HTML
        <h3 id="#{id_hash(id)}" data-title="+#{name}+">
          <code>#{name}</code> (<code>#{default}</code>)
        </h3>
    HTML
  end

  def l(type, name, url = nil)
    url ||= name

    if type == :event
      "<a href=\"##{id_hash('event-' + url)}\"><code>\"#{name}\"</code></a>"
    elsif type == :bare
      "<a href=\"#{url}\">#{name}</a>"
    else
      "<a href=\"##{id_hash(url)}\"><code>#{name}</code></a>"
    end
  end

  def id_hash(name)
    "#{id_prefix}#{name.to_s.gsub(/:/, '-')}".downcase
  end
end
