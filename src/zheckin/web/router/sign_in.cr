module Zheckin::Web::Router
  module SignIn
    alias WrapperApi = Zhihu::WrapperApi

    BASE_SECRET_KEY = Zheckin.get_app_env("base_secret_key")
  end

  resources :sign_in do
    post "/sign_in" do |context|
      data = context.params.json
      api_token = data["api_token"].as(String)
      email = data["email"].as(String)

      begin
        account = WrapperApi.self(api_token)
        clubs = account.clubs_reload
        exp = Time.utc.to_unix + (60 * 60 * 24 * 30) # 30天
        payload = {"account_id" => account.id, "exp" => exp, "iat" => Time.utc.to_unix}
        token = JWT.encode(payload, BASE_SECRET_KEY, JWT::Algorithm::HS256)

        token_cookie = HTTP::Cookie.new(
          name: "token",
          value: token,
          expires: Time.utc + 30.days
        )
        context.response.cookies << token_cookie

        unless email.empty?
          Store.update_account!(account, {:email => email})
        end

        pp email

        json_success(context, token: token, account: account, clubs: clubs.size > 0 ? clubs : nil, email_setted: !account.email.includes?("*"))
      rescue e : Crest::NotFound | Crest::Unauthorized
        json_error(context, "无效的认证令牌", status_code: 401)
      rescue e : Crest::RequestFailed
        json_error(context, "知乎给你提了一个错误：#{e.message || e.to_s}")
      rescue e : Exception
        json_error(context, e.message || e.to_s)
      end
    end

    get "/logout" do |context|
      token_cookie = HTTP::Cookie.new(
        name: "token",
        value: "",
        expires: Time.utc(1970, 1, 1)
      )

      context.response.cookies << token_cookie
      context.redirect "/"
    end
  end
end
