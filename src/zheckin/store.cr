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

  private macro defdelegate(name, *args, to method)
    def self.{{name.id}}(*args, **options)
      {{method.id}}(*args, **options)
    end
  end

  defdelegate :find_accounts, to: Account.find_list
  defdelegate :create_account!, to: Account.create!
  defdelegate :update_account!, to: Account.update!
  defdelegate :delete_account!, to: Account.delete!
  defdelegate :refresh_account_clubs!, to: Account.refresh_clubs!

  defdelegate :create_club!, to: Club.create!
  defdelegate :update_club!, to: Club.update!
  defdelegate :delete_club!, to: Club.delete!

  defdelegate :create_history!, to: History.create!
  defdelegate :update_history!, to: History.update!
  defdelegate :delete_history!, to: History.delete!

  impl :account, options: {:primary_type => String} do
    def self.find_list
      Account.all.to_a
    end

    def self.create!(data : Hash, clubs = Array(Model::Club).new)
      if clubs.size > 0
        Jennifer::Adapter.adapter.transaction do
          account = Account.create!(data)
          clubs.each { |club| account.add_clubs(club) }
        end
      else
        Account.create!(data)
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
        account.clubs_reload.each { |club| account.remove_clubs(club) }
        clubs.each { |club| account.add_clubs(club) }
      end
    end

    def self.delete!(account : Account)
      account.delete
    end
  end

  impl :club, options: {:primary_type => String} do
    def self.create!(data : Hash)
      Club.create!(data)
    end

    def self.update!(club : Club, data : Hash)
      account.update_columns(data)
    end

    def self.delete!(club : Club)
      club.delete
    end
  end

  impl :history do
    def self.create!(data : Hash)
      pp data
      History.create!(data)
    end

    def self.update!(history : History, data : Hash)
      history.update_columns(data)
    end

    def self.delete!(history : History)
      history.delete
    end
  end
end
