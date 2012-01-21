module BusterJsDocs
  class Page
    attr_reader :title, :html

    def initialize(template)
      @template = template
    end

    def parse
      lines = @template.split("\n")
      header = lines[0]

      if header.start_with?("<")
        @title = "Documentation"
        @html = @template
      else
        @title = header
        @html = "<h1>#{header}</h1>" + lines[1..-1].join("\n")
      end
    end
  end
end
