class CreateHomeAssistantStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :home_assistant_statuses do |t|
      t.string :status
      t.text :status_message
      t.string :smart_home_status
      t.text :connected_message
      t.text :disconnected_message

      t.timestamps
    end
  end
end
