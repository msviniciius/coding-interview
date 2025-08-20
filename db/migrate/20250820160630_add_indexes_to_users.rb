class AddIndexesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, 'LOWER(username)', name: 'index_users_on_lower_username' unless index_exists?(:users, 'LOWER(username)')
  end
end
