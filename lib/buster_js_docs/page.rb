require "nokogiri"

module BusterJsDocs
  class Page
    attr_reader :title, :html

    def initialize(template)
      @template = "<body>" + template + "</body>"
      @title = ""
    end

    def parse
      doc = Nokogiri::HTML(@template).css("body")[0]
      lines = @template.split("\n")
      header = lines[0]

      if doc.children[0].text?
        h1_title = Nokogiri::XML::Node.new("h1", doc)
        h1_title.inner_html = doc.children[0].text.chomp
        doc.children[0].replace(h1_title)
        @title = h1_title.inner_text
      end

      if doc.children[0].name == "h1"
        @title = doc.children[0].inner_text
      end

      @html = doc.inner_html
    end
  end
end
