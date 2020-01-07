require "./spec_helper"

alias Model = Zheckin::Model
alias Store = Zheckin::Store
alias Zhihu = Zheckin::Zhihu

zhihu_api_token = Zheckin.get_app_env("zhihu_api_token")

describe Zheckin do
  describe Zheckin::Store do
    it "changed_columns" do
      club = Model::Club.build({
        :id          => "1180068365795840000",
        :name        => "绝地求生",
        :description => "绝地求生（PUBG）PC 版交流。",
        :avatar      => "https://pic2.zhimg.com/v2-26d0fd84f32d6485e49146b0b7fbddae_b.jpg",
        :background  => "https://pic2.zhimg.com/v2-397569072031c88e7a8ed43e49901e3f_b.jpg",
      })

      changed = {:name => "[EMPTY]", :description => "空描述"}
      changed_data = Store.changed_columns(club, changed, [:name, :description, :avatar, :background])

      changed_data.should eq(changed)
    end

    accounts = Store.find_accounts
    accounts.size.should eq(0)

    account_data = {
      :id        => "7eb8dd6d1e665c9b53832a0d8ab3a4c2",
      :url_token => "Hentioe",
      :name      => "绅士喵",
      :email     => "me@bluerain.io",
      :avatar    => "https://pic4.zhimg.com/v2-654375a3519dcc4e478f88e206ceb695_{size}.jpg",
      :enabled   => true,
    }

    begin
      Store.create_account!(account_data)
    rescue e
      e.message.not_nil!.should end_with("api_token can't be casted from Nil to it's type - String")
    end

    account_data = account_data.merge({:api_token => zhihu_api_token})
    account = Store.create_account!(account_data)
    account.should be_truthy
    account.id.should eq("7eb8dd6d1e665c9b53832a0d8ab3a4c2")
    account.api_token.should eq(zhihu_api_token)

    account2 = Store.create_account!(account_data.merge({:id => "[TEMP]", :url_token => "[TEMP]"}))
    account2.should be_truthy
    account2.id.should eq("[TEMP]")
    account2.url_token.should eq("[TEMP]")

    accounts = Store.find_accounts
    accounts.size.should eq(2)

    account = Store.fetch_account!(account_data.merge({:name => "[EMPTY]"}))
    account.id.should eq("7eb8dd6d1e665c9b53832a0d8ab3a4c2")
    account.name.should eq("[EMPTY]")

    Store.update_account!(account, {:api_token => "[DELETED]"})
    account.api_token.should eq("[DELETED]")

    club_data = {
      :name        => "绝地求生",
      :description => "绝地求生（PUBG）PC 版交流。",
      :avatar      => "https://pic2.zhimg.com/v2-26d0fd84f32d6485e49146b0b7fbddae_b.jpg",
      :background  => "https://pic2.zhimg.com/v2-397569072031c88e7a8ed43e49901e3f_b.jpg",
    }

    begin
      Store.create_club!(club_data)
    rescue e
      e.message.not_nil!.should start_with("NOT NULL constraint failed: clubs.id")
    end

    club_data = club_data.merge({:id => "1180068365795840000"})
    club = Store.create_club!(club_data)
    club.should be_truthy
    club.not_nil!.id.should eq("1180068365795840000")
    account.not_nil!.clubs.size.should eq(0)

    Store.fetch_club!(club_data).id.should eq(club.id)

    club_data = club_data.merge({:id => "1180807024694255616"})
    Store.fetch_club!(club_data).id.should eq("1180807024694255616")

    Store.refresh_account_clubs!(account.not_nil!, [club])
    account.not_nil!.clubs.size.should eq(1)

    history_data = {
      :msg        => "OK",
      :account_id => "[TEMP]",
      :club_id    => "[TEMP]",
    }

    begin
      Store.create_history!(history_data)
    rescue e
      e.message.not_nil!.should start_with("FOREIGN KEY constraint failed")
    end

    history_data = history_data.merge({:account_id => account.id, :club_id => club.id})
    history = Store.create_history!(history_data)
    history.should be_truthy
    history.account_id.should eq(account.id)
    history.club_id.should eq(club.id)

    history_data = history_data.merge({:account_id => account2.id})
    history2 = Store.create_history!(history_data)
    history2.should be_truthy
    history2.account_id.should eq(account2.id)
    history2.club_id.should eq(club.id)

    Store.today_histories.size.should eq(2)
    Store.today_histories(account_id: account.id).size.should eq(1)
    Store.today_histories(club_id: club.id).size.should eq(2)
    Store.find_histories.size.should eq(2)
    Store.find_histories(account_id: account.id).size.should eq(1)
    Store.find_histories(club_id: club.id).size.should eq(2)

    account.clubs.size.should eq(1)
    club.histories.size.should eq(2)

    Store.delete_club!(club)
    account.clubs_reload.size.should eq(0)
    account.histories_reload.size.should eq(0)

    Store.today_histories.size.should eq(0)
    Store.find_histories.size.should eq(0)

    Store.delete_account!(account)
    Store::Account.get(account.id).should be_falsey
  end

  describe Zheckin::Zhihu do
    describe Zheckin::Zhihu::RawApi do
      it "clubs_joined" do
        begin
          Zhihu::RawApi.clubs_joined("[INVALID_API_TOKEN]")
        rescue e : Crest::Unauthorized
          e.response.status_code.should eq(401)
        end
        Zhihu::RawApi.clubs_joined(zhihu_api_token).status_code.should eq(200)
      end

      it "people" do
        begin
          Zhihu::RawApi.people("[INVALID_URL_TOKEN]")
        rescue e : Crest::NotFound
          e.response.status_code.should eq(404)
        end

        resp = Zhihu::RawApi.people("Hentioe")
        resp.status_code.should eq(200)
        json = JSON.parse(resp.body)
        json["id"].as_s.should eq("7eb8dd6d1e665c9b53832a0d8ab3a4c2")
      end

      it "clubs_checkin" do
        begin
          resp = Zhihu::RawApi.clubs_checkin(zhihu_api_token, "1180068365795840000")
          resp.status_code.should eq(200)
          json = JSON.parse(resp.body)
          json["success"].as_bool.should be_true
        rescue e : Crest::Forbidden
          resp = e.response
          resp.status_code.should eq(403)
          json = JSON.parse(resp.body)
          error = json["error"].as_h
          error["message"].as_s.should eq("已签到")
          error["code"].as_i.should eq(403)
        end
      end
    end

    describe Zheckin::Zhihu::WrapperApi do
      account = Zhihu::WrapperApi.self(zhihu_api_token)
      account.api_token.should eq(zhihu_api_token)

      clubs = Zhihu::WrapperApi.clubs_joined(account.not_nil!)
      (clubs.size > 0).should be_true

      Store.refresh_account_clubs!(account, clubs)
      (account.clubs_reload.size > 0).should be_true

      history = Zhihu::WrapperApi.clubs_checkin(account, "1180068365795840000")
      history.account_id.should eq(account.id)
      history.club_id.should eq("1180068365795840000")
      pp history
      ["OK", "已签到"].includes?(history.msg).should be_true

      histories = Zhihu::WrapperApi.clubs_checkin_all(account)
      histories.each do |history|
        history.account_id.should eq(account.id)
        ["OK", "已签到"].includes?(history.msg).should be_true
      end
    end
  end

  describe Zheckin::Web do
    describe Zheckin::Web::Router do
      post "/sign_in", headers: with_json, body: {api_token: "[INVALID_API_TOKEN]", email: ""}.to_json
      response.status.should eq(HTTP::Status::UNAUTHORIZED)
      sign_in_resp_json = JSON.parse(response.body)
      sign_in_resp_json["error"].as_h["msg"].as_s.should eq("无效的认证令牌")

      post "/sign_in", headers: with_json, body: {api_token: zhihu_api_token, email: ""}.to_json
      response.status.should eq(HTTP::Status::OK)
      sign_in_resp_json = JSON.parse(response.body)
      token = sign_in_resp_json["data"].as_h["token"].as_s

      describe Zheckin::Web::Router::Page do
        it "render /" do
          get "/"
          response.status.should eq(HTTP::Status::OK)
        end

        it "render 404" do
          get "/[not_found]"
          response.status.should eq(HTTP::Status::NOT_FOUND)
        end

        it "render console" do
          get "/console", headers: with_json
          response.status.should eq(HTTP::Status::UNAUTHORIZED)
        end
      end

      describe Zheckin::Web::Router::ConsoleApi do
        it "put /accounts/refresh_joined_clubs" do
          put "/console/api/accounts/refresh_joined_clubs", headers: with_auth(token)
          response.status.should eq(HTTP::Status::OK)
          json = JSON.parse(response.body)
          (json["data"].as_h["clubs"].size > 0).should be_true
        end

        it "post /clubs/:id/checkin" do
          post "/console/api/clubs/1180068365795840000/checkin", headers: with_auth(token)
          response.status.should eq(HTTP::Status::OK)
          json = JSON.parse(response.body)
          json["data"].as_h["history"].as_h["club_id"].as_s.should eq("1180068365795840000")
        end

        it "post /clubs/checkin_all" do
          post "/console/api/clubs/checkin_all", headers: with_auth(token)
          response.status.should eq(HTTP::Status::OK)
          json = JSON.parse(response.body)
          (json["data"].as_h["histories"].as_a.size > 0).should be_true
        end

        it "get /histories/today" do
          get "/console/api/histories/today", headers: with_auth(token)
          response.status.should eq(HTTP::Status::OK)
          json = JSON.parse(response.body)
          (json["data"].as_h["histories"].as_a.size > 0).should be_true
        end

        it "get /histories/clubs/:id" do
          get "/console/api/histories/clubs/1180068365795840000?limit=1", headers: with_auth(token)
          response.status.should eq(HTTP::Status::OK)
          json = JSON.parse(response.body)
          json["data"].as_h["histories"].as_a.size.should eq(1)
        end
      end
    end
  end
end
