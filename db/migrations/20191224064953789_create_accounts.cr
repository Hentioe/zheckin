class CreateAccounts < Jennifer::Migration::Base
  def up
    create_table :accounts, id: false do |t|
      t.string :id, {:null => false, :primary => true}
      t.string :url_token, {:null => false}
      t.string :name, {:null => false}
      t.string :email, {:null => false}
      t.string :avatar, {:null => false}
      t.string :api_token, {:null => false}

      t.timestamps
    end

    add_index :accounts, [:url_token], :unique
  end

  def down
    drop_index :accounts, [:url_token]
    drop_table :accounts if table_exists? :accounts
  end
end
