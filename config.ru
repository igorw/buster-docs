require "buster_docs_middleware"
require "rack/static"

use Rack::Static, {
  :urls => ["/stylesheets", "/javascripts", "/favicon.ico", "/images"],
  :root => "public"
}

run BusterDocsMiddleware.new
