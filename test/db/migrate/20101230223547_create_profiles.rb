class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.references :user
      t.string :password
      t.boolean :checked
    end
  end

  def self.down
    drop_table :profiles
  end
end
