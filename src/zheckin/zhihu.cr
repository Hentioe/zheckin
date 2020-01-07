require "crest"

module Zheckin::Zhihu
  module RawApi
    LOGGING = Zheckin.get_app_env?("env") == "test"

    COMMON_API_TOKEN = Zheckin.get_app_env("zhihu_api_token")
    BASE_HEADERS     = {
      "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64; rv:70.0) Gecko/20100101 Firefox/70.0",
    }

    def self.clubs_joined(api_token : String, limit = 20, offset = 0)
      endpoint = "https://www.zhihu.com/api/v4/clubs/joined?limit=#{limit}&offset=#{offset}"
      headers = BASE_HEADERS.merge({"Cookie" => "z_c0=#{api_token}"})

      Crest.get(endpoint, headers: headers, logging: LOGGING)
    end

    def self.people(url_token : String, api_token = COMMON_API_TOKEN)
      endpoint = "https://api.zhihu.com/people/#{url_token}"
      headers = BASE_HEADERS.merge({"Cookie" => "z_c0=#{api_token}"})

      Crest.get(endpoint, headers: headers, logging: LOGGING)
    end

    def self.self(api_token : String)
      people("self", api_token: api_token)
    end

    def self.clubs_checkin(api_token : String, club_id : String)
      endpoint = "https://www.zhihu.com/api/v4/clubs/#{club_id}/checkin"
      headers = BASE_HEADERS.merge({"Cookie" => "z_c0=#{api_token}"})

      Crest.post(endpoint, headers: headers, logging: LOGGING)
    end

    LOGOUT_ENDPOINT = "https://www.zhihu.com/logout"

    def self.logout(api_token : String)
      headers = BASE_HEADERS.merge({"Cookie" => "z_c0=#{api_token}"})

      Crest.get(LOGOUT_ENDPOINT, headers: headers, max_redirects: 0, logging: LOGGING)
    end
  end

  module WrapperApi
    def self.self(api_token : String) : Model::Account
      resp = RawApi.self(api_token)
      json = JSON.parse(resp.body)

      account_data = {
        :id        => json["id"].as_s,
        :url_token => json["url_token"].as_s,
        :name      => json["name"].as_s,
        :email     => json["email"].as_s,
        :avatar    => json["avatar_url_template"].as_s,
        :api_token => api_token,
      }

      Store.fetch_account!(account_data)
    end

    def self.clubs_joined(account : Model::Account,
                          clubs = Array(Model::Club).new,
                          limit = 20,
                          offset = 0) : Array(Model::Club)
      resp = RawApi.clubs_joined(account.api_token, limit: limit, offset: offset)
      json = JSON.parse(resp.body)

      paging = json["paging"].as_h
      data = json["data"].as_a

      data.each do |club|
        club = club.as_h
        club_data = {
          :id          => club["id"].as_s,
          :name        => club["name"].as_s,
          :description => club["description"].as_s,
          :avatar      => club["avatar"].as_s,
          :background  => club["background"].as_s,
        }

        clubs << Store.fetch_club!(club_data)
      end

      if paging["is_end"].as_bool || offset > 55
        return clubs
      else
        clubs_joined(account, clubs, limit, (offset + 1) * limit)
      end
    end

    def self.clubs_checkin(account : Model::Account, club_id : String) : Model::History
      history_data = {
        :account_id => account.id,
        :club_id    => club_id,
      }

      begin
        resp = RawApi.clubs_checkin(account.api_token, club_id)
        json = JSON.parse(resp.body)

        if json["success"].as_bool
          Store.create_history!(history_data.merge({:msg => "OK"}))
        else
          Store.create_history!(history_data.merge({:msg => "OK?"}))
        end
      rescue e : Crest::Forbidden
        resp = e.response
        json = JSON.parse(resp.body)
        error = json["error"].as_h
        Store.create_history!(history_data.merge({:msg => error["message"].as_s}))
      rescue e : Exception
        Store.create_history!(history_data.merge({:msg => e.message}))
      end
    end

    def self.clubs_checkin_all(account : Model::Account) : Array(Model::History)
      account.clubs_reload.map do |club|
        clubs_checkin(account, club.id.not_nil!)
      end
    end

    def self.logout(account : Model::Account)
      begin
        RawApi.logout(account.api_token)
      rescue Crest::Found
        Store.update_account!(account, {:api_token => "[REVOKED]", :enabled => false})
      end
    end
  end
end
