class AddHolderShares < ActiveRecord::Migration[7.0]
  def up
    remove_column :holdings, :holder_id if column_exists?(:holdings, :holder_id)
    remove_column :shares, :holder_id if column_exists?(:shares, :holder_id)
    add_reference :shares, :holder, null: true, foreign_key: false

   # Backfill existing holdings -> assign them to the default holder

    # 2. Find the default holder
    result = execute("SELECT id FROM holders WHERE `default` = 1")
    # chatGpt expected an object here, but it just returned an array of arrays of values - i.e. [[1]]
    #holder_ids = result.map { |row| row['id'] }
    holder_ids = result.map { |row| row.first }

    if holder_ids.empty?
      raise ActiveRecord::IrreversibleMigration, "No default holder found"
    elsif holder_ids.size > 1
      raise ActiveRecord::IrreversibleMigration, "More than one default holder found"
    end

    default_holder_id = holder_ids.first


    execute <<~SQL
      UPDATE shares
      SET holder_id = #{default_holder_id}
      WHERE holder_id IS NULL;
    SQL

    # 3. Now enforce NOT NULL constraint
    change_column_null :shares, :holder_id, false
  end

  def down
    # Rollback: just drop the reference
    remove_reference :shares, :holder
  end
end
