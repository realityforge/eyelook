class AddUser < ActiveRecord::Migration
  def self.up
    create_table 'users', :force => true do |t|
      t.column 'name', :string, :limit => 20, :null => false
      t.column 'password', :string, :limit => 40, :null => false
      t.column 'salt', :string, :limit => 40, :null => false
    end
    add_index 'users', ['name'], :name => 'users_name_index', :unique => true
  end

  def self.down
    drop_table 'users'
  end
end
