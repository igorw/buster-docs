require "nokogiri"

module BusterJsDocs
  class Page
    attr_reader :title, :html

    def initialize(template)
      @template = template
    end

    def parse
      doc = Nokogiri::HTML(@template)
      lines = @template.split("\n")
      header = lines[0]

      if header.start_with?("<")
        title_h1 = doc.css("h1")[0]
        if title_h1
          @title = title_h1.inner_text
        else
          @title = "Documentation"
        end
        @html = @template
      else
        @title = header
        @html = "<h1>#{header}</h1>\n" + lines[1..-1].join("\n")
      end
    end
  end
end
