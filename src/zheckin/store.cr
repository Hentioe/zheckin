require "../../config/*"

module Zheckin::Store
  macro impl(name, options = {:primary_type => Int32})
    {{module_name = name.camelcase}}

    module {{module_name.id}}
      alias {{module_name.id}} = Model::{{module_name.id}}

      def self.get(id : {{options[:primary_type]}}?)
        {{module_name.id}}.find(id)
      end

      {{yield}}
    end
  end

  macro changed_columns(model, data, fields)
    %changed_columns = {} of Symbol => String | Bool
    {% for field in fields %}
      if (%change = {{data}}[{{field}}]?) && {{model}}.{{field.id}} != %change
        %changed_columns[{{field}}] = {{data}}[{{field}}]
      end
    {% end %}

    %changed_columns
  end

  defdelegate :find_accounts, to: Account.find_list
  defdelegate :create_account!, to: Account.create!
  defdelegate :fetch_account!, to: Account.fetch!
  defdelegate :update_account!, to: Account.update!
  defdelegate :delete_account!, to: Account.delete!
  defdelegate :refresh_account_clubs!, to: Account.refresh_clubs!

  defdelegate :create_club!, to: Club.create!
  defdelegate :fetch_club!, to: Club.fetch!
  defdelegate :update_club!, to: Club.update!
  defdelegate :delete_club!, to: Club.delete!

  defdelegate :create_history!, to: History.create!
  defdelegate :update_history!, to: History.update!
  defdelegate :delete_history!, to: History.delete!
  defdelegate :find_histories, to: History.find_list
  defdelegate :today_histories, to: History.today_list

  impl :account, options: {:primary_type => String} do
    REQUIRE_FIELDS = %i(url_token name avatar api_token)

    def self.find_list
      Account.all.to_a
    end

    def self.create!(data : Hash, clubs = Array(Model::Club).new)
      if clubs.size > 0
        Jennifer::Adapter.adapter.transaction do
          account = Account.create!(data)
          clubs.each { |club| account.add_clubs(club) }
          account
        end.not_nil!
      else
        Account.create!(data)
      end
    end

    def self.fetch!(data : Hash)
      id = data[:id]
      if account = Account.where { _id == id }.first
        changed_data = Store.changed_columns(account, data, {{REQUIRE_FIELDS}})
        if changed_data.size > 0
          update!(account, changed_data)
        end
        account
      else
        if data[:enabled]? == nil
          data = data.merge({:enabled => true})
        end
        create!(data)
      end
    end

    def self.update!(account : Account, data : Hash, clubs = Array(Model::Club).new)
      if clubs.size > 0
        Jennifer::Adapter.adapter.transaction do
          account.update_columns(data)
          refresh_clubs!(account, clubs)
        end
      else
        account.update_columns(data)
      end
    end

    def self.refresh_clubs!(account : Account, clubs : Array(Model::Club))
      Jennifer::Adapter.adapter.transaction do
        account.clubs_reload.clone.each { |club| account.remove_clubs(club) }
        clubs.each { |club| account.add_clubs(club) }
      end
    end

    def self.delete!(account : Account)
      account.delete
    end
  end

  impl :club, options: {:primary_type => String} do
    REQUIRE_FIELDS = %i(name description avatar background)

    def self.create!(data : Hash)
      Club.create!(data)
    end

    def self.fetch!(data : Hash)
      id = data[:id]
      if club = Club.where { _id == id }.first
        changed_data = Store.changed_columns(club, data, {{REQUIRE_FIELDS}})
        if changed_data.size > 0
          update!(club, changed_data)
        end
        club
      else
        create!(data)
      end
    end

    def self.update!(club : Club, data : Hash)
      club.update_columns(data)
    end

    def self.delete!(club : Club)
      club.delete
    end
  end

  impl :history do
    def self.create!(data : Hash)
      History.create!(data)
    end

    def self.update!(history : History, data : Hash)
      history.update_columns(data)
    end

    def self.delete!(history : History)
      history.delete
    end

    def self.all
      History.all.to_a
    end

    def self.today_list(account_id : String? = nil, club_id : String? = nil)
      now = Time.utc
      offset_seconds = Time.local.offset
      midnight_twelve = Time.utc(now.year, now.month, now.day, 0, 0, 0) - offset_seconds.seconds

      case {account_id, club_id}
      when {nil, nil}
        History.where { _created_at >= midnight_twelve }.to_a
      when {account_id, nil}
        History.where { (_account_id == account_id.not_nil!) & (_created_at >= midnight_twelve) }.to_a
      when {nil, club_id}
        History.where { (_club_id == club_id.not_nil!) & (_created_at >= midnight_twelve) }.to_a
      else
        History.where {
          (_account_id == account_id.not_nil!) & (_club_id == club_id.not_nil!) & (_created_at >= midnight_twelve)
        }.to_a
      end
    end

    def self.find_list(account_id : String? = nil, club_id : String? = nil, offset = 0, limit = 999)
      query =
        case {account_id, club_id}
        when {nil, nil}
          History.all
        when {account_id, nil}
          History.where { _account_id == account_id.not_nil! }
        when {nil, club_id}
          History.where { _club_id == club_id.not_nil! }
        else
          History.where { (_account_id == account_id.not_nil!) & (_club_id == club_id.not_nil!) }
        end

      query.offset(offset).limit(limit).to_a
    end
  end
end
