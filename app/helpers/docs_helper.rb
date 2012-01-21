module DocsHelper
  def anchor(text, target = nil)
    target ||= text
    "<a href=\"#{ref(target)}\">#{text}</a>".html_safe
  end

  def ref(name)
    "##{id(name)}"
  end

  def id(name)
    "#{id_prefix}#{name.to_s.sub(/^#/, '').gsub(/[:\.]/, '-')}"
  end

  def id_prefix
    ""
  end

  # Link to a buster module
  # +name+ should be like "eventEmitter", will be presented as
  # "buster.eventEmitter"
  def m(name, display_name = nil)
    display_name ||= "buster-#{name}"
    url = doc_url("buster-#{decamelize(name)}")

    if name =~ /.+#/
      pieces = name.split("#")
      url = doc_url("buster-#{decamelize(pieces[0])}") + "##{pieces[1]}"
    end

    "<a href=\"#{url}\">#{display_name}</a>".html_safe
  end

  def decamelize(name, sep = "-")
    name.split(/([A-Z])/).inject("") do |str, item|
      str += (item == item.upcase ? "#{sep}" : "") + item.downcase
    end
  end

  def doc_url(path)
    context_path + path.gsub(/^\/*|\/*$/, "/")
  end

  def context_path
    ""
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

    out = <<-HTML
        <h3 id="#{id('event-' + name)}" data-title="+#{name}+">
          Event: <code>"#{name}", function (#{args.join(', ')}) {}</code>
        </h3>
    HTML

    out.html_safe
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

  def property(name, default = nil)
    default = default.nil? ? "" : " (<code>#{default}</code>)"

    out = <<-HTML
        <h3 id="#{id(name)}" data-title="+#{name}+">
          <code>#{name}</code>#{default}
        </h3>
    HTML

    out.html_safe
  end

  def img(src, attr = {})
    "<img src=\"/images/#{src}\" #{attr.collect { |kv| "#{kv[0]}=\"#{kv[1]}\"" }.join(' ')}>".html_safe
  end
end
