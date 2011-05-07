require "buster_docs_middleware"
require "rack/static"

run BusterDocsMiddleware.new
