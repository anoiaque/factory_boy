class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.references :user
      t.string :password
    end
  end

  def self.down
    drop_table :profiles
  end
end
