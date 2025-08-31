class PopulateHolders < ActiveRecord::Migration[7.0]
  def up
    Holder.create!(name: "ari", colour: "lightseagreen", default: true)
    Holder.create!(name: "jack", colour: "chocolate", default: false)
  end

  def down
    Holder.where(name: ["ari", "jack"]).delete_all
  end
end
