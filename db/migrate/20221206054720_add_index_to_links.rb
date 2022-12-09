
class AddIndexToLinks < ActiveRecord::Migration[7.0]
  def change
    # - in the end we didnt need it - its created automatically add_index :links, [:linked_to_type, :linked_to_id]
  end
end
