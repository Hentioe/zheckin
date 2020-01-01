module Zheckin::Web::Router
  module Page
    private macro def_index_routes(routes)
      {% for route in routes %}
        get {{route}} do |context|
          render "src/views/user.html.ecr"
        end
      {% end %}
    end
  end

  resources :page do
    def_index_routes ["/", "/sign_in"]
  end

  error 404 do |context|
    "Not Found"
  end
end
