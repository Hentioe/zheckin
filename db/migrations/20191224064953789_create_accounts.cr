class CreateAccounts < Jennifer::Migration::Base
  def up
    create_table :accounts, id: false do |t|
      t.string :id, {:null => false, :primary => true}
      t.string :email, {:null => false}
      t.string :name, {:null => false}
      t.string :avatar, {:null => false}
      t.string :z_c0, {:null => false}

      t.timestamps
    end
  end

  def down
    drop_table :accounts if table_exists? :accounts
  end
end
