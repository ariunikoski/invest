
class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :target_url
      t.string :name
      t.references :linked_to, polymorphic: true, null: false

      t.timestamps
    end

  end
end
