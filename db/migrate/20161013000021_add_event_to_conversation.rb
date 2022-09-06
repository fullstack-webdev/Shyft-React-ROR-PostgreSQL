class AddEventToConversation < ActiveRecord::Migration
  def change
    add_reference :conversations, :event, index: true
    add_foreign_key :conversations, :events
  end
end
