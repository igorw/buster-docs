require "nokogiri"

module BusterJsDocs
  class Page
    attr_reader :title, :html

    def initialize(template)
      @template = template
    end

    def parse
      doc = Nokogiri::HTML(@template).css("body")[0]
      lines = @template.split("\n")
      header = lines[0]

      if doc.children[0].name != "h1"
        h1_title = Nokogiri::XML::Node.new("h1", doc)
        h1_title.inner_html = doc.children[0].inner_html.chomp
        doc.children[0].replace(h1_title)
      end

      @title = doc.children[0].inner_text
      @html = doc.inner_html
    end
  end
end
