module Zheckin::Web::Router
  module Page
    SELF_API_TOKEN = Zheckin.get_app_env("zhihu_api_token")
  end

  resources :page do
    get "/" do |context|
      # json(context, Store.personal_all_histories(SELF_API_TOKEN))
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
