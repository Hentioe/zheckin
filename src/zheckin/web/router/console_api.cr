module Zheckin::Web::Router
  module ConsoleApi
    INVALID_API_TOKEN = "无效的认证令牌"

    def self.error_from_zhihu(ex)
      "知乎给你提了一个错误：#{ex.message || ex.to_s}"
    end
  end

  resources :console_api, options: {:prefix => "/console/api"} do
    put "/accounts/refresh_joined_clubs" do |context|
      account = context.get("account").as(Model::Account)

      begin
        clubs = Zhihu::WrapperApi.clubs_joined(account)
        Store.refresh_account_clubs!(account, clubs)

        json_success(context, clubs: clubs)
      rescue e : Crest::Unauthorized
        json_error(context, INVALID_API_TOKEN)
      rescue e : Crest::RequestFailed
        json_error(context, error_from_zhihu(e))
      end
    end

    post "/clubs/:id/checkin" do |context|
      club_id = context.params.url["id"]
      account = context.get("account").as(Model::Account)

      history = Zhihu::WrapperApi.clubs_checkin(account, club_id)
      json_success(context, history: history)
    end

    post "/clubs/checkin_all" do |context|
      account = context.get("account").as(Model::Account)

      histories = Zhihu::WrapperApi.clubs_checkin_all(account)
      json_success(context, histories: histories)
    end
  end
end
