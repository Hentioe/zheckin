module Zheckin::Web::Router
  module SignIn
    alias WrapperApi = Zhihu::WrapperApi

    BASE_SECRET_KEY = Zheckin.get_app_env("base_secret_key")
  end

  resources :sign_in do
    post "/sign_in" do |context|
      data = context.params.json
      api_token = data["api_token"].as(String)

      begin
        account = WrapperApi.self(api_token)
        clubs = WrapperApi.clubs_joined(account)
        Store.refresh_account_clubs!(account, clubs)

        exp = Time.utc.to_unix + (60 * 60 * 24 * 30) # 30天
        payload = {"account_id" => account.id, "exp" => exp, "iat" => Time.utc.to_unix}
        token = JWT.encode(payload, BASE_SECRET_KEY, JWT::Algorithm::HS256)

        token_cookie = HTTP::Cookie.new(
          name: "token",
          value: token,
          expires: Time.utc + 30.days
        )
        context.response.cookies << token_cookie

        json_success(context, token: token, account: account)
      rescue e : Crest::NotFound | Crest::Unauthorized
        json_error(context, "无效的认证令牌")
      rescue e : Crest::RequestFailed
        json_error(context, "知乎给你提了一个错误：#{e.message || e.to_s}")
      rescue e : Exception
        json_error(context, e.message || e.to_s)
      end
    end
  end
end
