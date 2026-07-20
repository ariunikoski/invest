class AddRestrictedToHolderToUsers < ActiveRecord::Migration[7.0]
  def change
	    add_reference :users,
                  :restricted_to_holder,
                  foreign_key: { to_table: :holders },
                  null: true
  end
end
