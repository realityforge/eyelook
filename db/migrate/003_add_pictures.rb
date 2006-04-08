class AddPictures < ActiveRecord::Migration
  def self.up
    create_table 'pictures', :force => true do |t|
      t.column 'album_id', :integer, :null => false
      t.column 'caption', :string, :limit => 50, :null => false
      t.column 'description', :text
      t.column 'content_type', :string, :limit => 25, :null => false
      t.column 'width', :integer, :null => false
      t.column 'height', :integer, :null => false
      t.column 'position', :integer, :null => false
      t.column 'created_at', :datetime, :null => false
      t.column 'updated_at', :datetime, :null => false
    end
    add_index 'pictures', ['caption'], :name => 'pictures_caption_index'
    add_index 'pictures', ['position'], :name => 'pictures_position_index'
    add_foreign_key_constraint 'pictures', 'album_id', 'albums', 'id', :name => 'pictures_album_id_fk'

    create_table('picture_data', :force => true) do |t|
      t.column 'picture_id', :integer, :null => false
      t.column 'data', :binary, :null => false
    end
    add_foreign_key_constraint 'picture_data', 'picture_id', 'pictures', 'id', :name => 'picture_data_picture_id_fk'
  end

  def self.down
    drop_table 'picture_data'
    drop_table 'pictures'
  end
end
