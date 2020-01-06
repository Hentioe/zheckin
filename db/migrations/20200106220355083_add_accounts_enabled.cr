class AddAccountsEnabled < Jennifer::Migration::Base
  def up
    change_table :accounts do |t|
      t.add_column :enabled, :bool, {:null => false, :default => true}
    end
  end

  def down
    change_table :accounts do |t|
      t.drop_column :enabled
    end
  end
end
