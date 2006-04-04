class AddAlbums < ActiveRecord::Migration
  def self.up
    create_table 'albums', :force => true do |t|
      t.column 'user_id', :integer, :null => false
      t.column 'name', :string, :limit => 50, :null => false
      t.column 'description', :text
      t.column 'position', :integer, :null => false
      t.column 'created_at', :datetime, :null => false
      t.column 'updated_at', :datetime, :null => false
    end
    add_index 'albums', ['name'], :name => 'albums_name_index', :unique => true
    add_index 'albums', ['position'], :name => 'albums_position_index'
    add_foreign_key_constraint 'albums', 'user_id', 'users', 'id', :name => 'albums_user_id_fk'
  end

  def self.down
    drop_table 'albums'
  end
end
