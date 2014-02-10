class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :full_name
      t.text :info

      t.timestamps
    end
  end
end
