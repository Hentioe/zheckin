require "jwt"

module Zheckin::Web
  class AuthHandler < Kemal::Handler
    BASE_SECRET_KEY = Zheckin.get_app_env("base_secret_key")

    def initialize
    end

    def call(context)
      if token_cookie = context.request.cookies["token"]?
        token = token_cookie.value
        begin
          payload, _ = JWT.decode(token, BASE_SECRET_KEY, JWT::Algorithm::HS256)
          context.account_id = payload["account_id"].as_s
        rescue e
          token_cookie = HTTP::Cookie.new(
            name: "token",
            value: "",
            expires: Time.utc(1970, 1, 1)
          )

          context.response.cookies << token_cookie
        end
      end
      call_next context
    end
  end
end
