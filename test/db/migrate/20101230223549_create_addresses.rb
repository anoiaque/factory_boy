class CreateAddresses< ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references :user
      t.string :street
      t.integer :number
    end
  end

  def self.down
    drop_table :addresses
  end
end
