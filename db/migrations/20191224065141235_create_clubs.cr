class CreateClubs < Jennifer::Migration::Base
  def up
    create_table :clubs, id: false do |t|
      t.string :id, {:null => false, :primary => true}
      t.string :name, {:null => false}
      t.string :description, {:null => false}
      t.string :avatar, {:null => false}
      t.string :background, {:null => false}

      t.timestamps
    end
  end

  def down
    drop_table :clubs if table_exists? :clubs
  end
end
