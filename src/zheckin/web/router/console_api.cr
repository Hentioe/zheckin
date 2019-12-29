module Zheckin::Web::Router
  resources :console_api, options: {:prefix => "/console/api"} do
    put "/accounts/refresh_joined_clubs" do |context|
      account = context.get("account").as(Model::Account)

      begin
        clubs = Zhihu::WrapperApi.clubs_joined(account)
        Store.refresh_account_clubs!(account, clubs)

        json_success(context, clubs: clubs)
      rescue e : Crest::Unauthorized
        json_error(context, "无效的认证令牌")
      rescue e : Crest::RequestFailed
        json_error(context, "知乎给你提了一个错误：#{e.message || e.to_s}")
      rescue e : Exception
        json_error(context, e.message || e.to_s)
      end
    end
  end
end
