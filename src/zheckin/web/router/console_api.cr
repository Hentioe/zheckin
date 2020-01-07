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

    put "/accounts/disabled" do |context|
      account = context.get("account").as(Model::Account)

      begin
        Store.update_account!(account, {:enabled => !account.enabled})

        json_success(context, account: account)
      rescue e
        json_error(context, e.message || e.to_s)
      end
    end

    get "/clubs/joined" do |context|
      account = context.get("account").as(Model::Account)

      json_success(context, clubs: account.clubs_reload)
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

    get "/histories/today" do |context|
      account = context.get("account").as(Model::Account)

      histories = Store.today_histories(account_id: account.id).map do |h|
        h.club_reload
        h
      end
      json_success(context, histories: histories)
    end

    get "/histories/clubs/:id" do |context|
      club_id = context.params.url["id"]
      offset = context.params.query["offset"]? || "0"
      limit = context.params.query["limit"]? || "25"
      account = context.get("account").as(Model::Account)

      histories = Store.find_histories(account_id: account.id, club_id: club_id, offset: offset.to_i, limit: limit.to_i)
      json_success(context, histories: histories)
    end
  end
end
