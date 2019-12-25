class CreateClubsAccounts < Jennifer::Migration::Base
  def up
    create_table :clubs_accounts, id: false do |t|
      t.reference :club, :string, {:null => false, :on_delete => :cascade}
      t.reference :account, :string, {:null => false, :on_delete => :cascade}
    end
  end

  def down
    drop_table :clubs_accounts if table_exists? :clubs_accounts
  end
end
