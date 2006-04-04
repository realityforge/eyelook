class AddSessions < ActiveRecord::Migration
  def self.up
    create_table 'sessions', :force => true do |t|
      t.column 'sessid', :string, :limit => 32, :null => false
      t.column 'data', :text
      t.column 'created_on', :timestamp, :null => false
      t.column 'updated_on', :timestamp, :null => false
    end
    add_index 'sessions', ['sessid'], :name => 'sessions_sessid_index', :unique => true
  end

  def self.down
    drop_table 'sessions'
  end
end
