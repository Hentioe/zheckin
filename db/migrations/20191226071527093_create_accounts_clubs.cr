class CreateAccountsClubs < Jennifer::Migration::Base
  def up
    create_table :accounts_clubs, id: false do |t|
      t.reference :account, :string, {:null => false, :on_delete => :cascade}
      t.reference :club, :string, {:null => false, :on_delete => :cascade}
    end
  end

  def down
    drop_table :accounts_clubs if table_exists? :accounts_clubs
  end
end
