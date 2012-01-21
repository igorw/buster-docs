BusterJsDocs::Application.routes.draw do
  match "(*path)" => "docs#show"
end
