class CreateHistories < Jennifer::Migration::Base
  def up
    create_table :histories do |t|
      t.reference :account, :string, {:null => false, :on_delete => :cascade}
      t.reference :club, :string, {:null => false, :on_delete => :cascade}

      t.string :msg, {:null => false}

      t.timestamp :created_at, {:null => false}
    end
  end

  def down
    drop_table :histories if table_exists? :histories
  end
end
