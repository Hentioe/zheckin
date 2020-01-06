class AddAccountsClubsIndex < Jennifer::Migration::Base
  def up
    add_index :accounts_clubs, [:account_id, :club_id], :unique
  end

  def down
    drop_index :accounts_clubs, [:account_id, :club_id]
  end
end
