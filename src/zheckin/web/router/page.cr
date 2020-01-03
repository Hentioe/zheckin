module Zheckin::Web::Router
  module Page
    private macro def_index_routes(paths)
      {% for path in paths %}
        get {{path}} do |context|
          render "src/views/user.html.ecr"
        end
      {% end %}
    end

    private macro def_console_routes(paths)
      {% for path in paths %}
        get {{path}} do |context|
          render "src/views/console.html.ecr"
        end
      {% end %}
    end
  end

  resources :page do
    def_index_routes ["/", "/sign_in"]
    def_console_routes ["/console"]
  end

  error 404 do |context|
    "Not Found"
  end
end
