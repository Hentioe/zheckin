module Zheckin::Web::Router
  resources :page do
    get "/" do |context|
      render "src/views/user.html.ecr"
    end

    error 404 do |context|
      if body = context.get? "body"
        body
      else
        "Not Found"
      end
    end
  end
end
