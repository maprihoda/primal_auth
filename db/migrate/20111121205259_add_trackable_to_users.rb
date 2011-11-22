class AddTrackableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_login_at, :datetime
    add_column :users, :last_logout_at, :datetime
    add_column :users, :last_activity_at, :datetime
    add_column :users, :login_count, :integer, :default => 0
    add_column :users, :last_login_ip, :string
  end
end

