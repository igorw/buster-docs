require "test_helper"
require "buster_js_docs/page"

class BusterJsDocsPageTest < ActiveSupport::TestCase
  test "page without magic title" do
    template = "<h1>My own title</h1>\n<p>foo</p>"
    page = BusterJsDocs::Page.new(template)
    page.parse

    assert_equal template, page.html
  end

  test "page with magic title" do
    template = "Magic title\n<p>foo</p>"
    page = BusterJsDocs::Page.new(template)
    page.parse

    assert_equal "Magic title", page.title
    assert_equal "<h1>Magic title</h1>\n<p>foo</p>", page.html
  end
end
