BusterJsDocs::Application.routes.draw do
  root :to => "docs#show"
  match "(*path)" => "docs#show"
end
