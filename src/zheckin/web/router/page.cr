module Zheckin::Web::Router
  resources :page do
    get "/" do |context|
      json(context, Store.find_histories)
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
