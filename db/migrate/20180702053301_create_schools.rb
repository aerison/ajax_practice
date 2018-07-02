class CreateSchools < ActiveRecord::Migration[5.2]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :address
      t.float :lng
      t.float :lat

      t.timestamps
    end
  end
end
