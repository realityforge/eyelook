class AddTags < ActiveRecord::Migration
  def self.up
    create_table 'tags', :force => true do |t|
      t.column 'name', :string, :limit => 40, :null => false
    end
    add_index 'tags', ['name'], :name => 'tags_name_index', :unique => true

    create_table 'tags_pictures', :force => true, :id => false do |t|
      t.column 'tag_id', :integer, :null => false
      t.column 'picture_id', :integer, :null => false
    end
    add_index 'tags_pictures', ['tag_id'], :name => 'tags_pictures_tag_id_index'
    add_index 'tags_pictures', ['picture_id'], :name => 'tags_pictures_picture_id_index'
    add_index 'tags_pictures', ['tag_id', 'picture_id'], :name => 'tags_pictures_tag_id_picture_id_index', :unique => true
    add_foreign_key_constraint 'tags_pictures', 'tag_id', 'tags', 'id', :name => 'tags_pictures_tag_id_fk'
    add_foreign_key_constraint 'tags_pictures', 'picture_id', 'pictures', 'id', :name => 'tags_pictures_picture_id_fk'

    create_table 'tags_albums', :force => true, :id => false do |t|
      t.column 'tag_id', :integer, :null => false
      t.column 'album_id', :integer, :null => false
    end
    add_index 'tags_albums', ['tag_id'], :name => 'tags_albums_tag_id_index'
    add_index 'tags_albums', ['album_id'], :name => 'tags_albums_album_id_index'
    add_index 'tags_albums', ['tag_id', 'album_id'], :name => 'tags_albums_tag_id_album_id_index', :unique => true
    add_foreign_key_constraint 'tags_albums', 'tag_id', 'tags', 'id', :name => 'tags_albums_tag_id_fk'
    add_foreign_key_constraint 'tags_albums', 'album_id', 'albums', 'id', :name => 'tags_albums_album_id_fk'
  end

  def self.down
    drop_table 'tags_albums'
    drop_table 'tags_pictures'
    drop_table 'tags'
  end
end
