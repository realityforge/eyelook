require File.dirname(__FILE__) + '/../test_helper'


class FakeFile
  attr_accessor :original_filename, :content_type, :read
  def initialize(original_filename, content_type, read)
    @original_filename = original_filename
    @content_type = content_type
    @read = read
  end
end

require 'picture'
class Picture < ActiveRecord::Base
  def self.base_part_of2(file_name); base_part_of(file_name); end
end

class PictureTest < Test::Unit::TestCase
  def test_base_part_of
    assert_equal('file.txt', Picture.base_part_of2('/a/b/c/file.txt'))
    assert_equal('file.txt', Picture.base_part_of2('C:\a\file.txt'))
  end

  def test_basic_load
    assert_kind_of Picture, pictures(:pictures_1)
    assert_equal 1, pictures(:pictures_1).id
    assert_equal 1, pictures(:pictures_1).album_id
    assert_equal 'Go baby! Go!', pictures(:pictures_1).caption
    assert_equal 'Nobody fucks with the Jesus - this is why!', pictures(:pictures_1).description
    assert_equal 2, pictures(:pictures_1).position
    assert_not_nil pictures(:pictures_1).created_at
    assert_not_nil pictures(:pictures_1).updated_at

    assert_nil pictures(:pictures_1).lower_item
    assert_not_nil pictures(:pictures_1).higher_item
    assert_equal 1, pictures(:pictures_1).higher_item.position
    assert_equal 1, pictures(:pictures_1).album.id

    assert_equal 2, pictures(:pictures_1).tag_names.size
    assert pictures(:pictures_1).tag_names.include?('happy')
    assert pictures(:pictures_1).tag_names.include?('sad')
  end

  def test_data_setter
    picture = Picture.new
    picture.data = FakeFile.new('C:\a\file.txt','text/plain','ABCDEFGHIJKLMNOPQRSTUVWXYZ')
    assert_equal('file.txt', picture.picture_data.name)
    assert_equal('text/plain', picture.picture_data.content_type)
    assert_equal('ABCDEFGHIJKLMNOPQRSTUVWXYZ', picture.picture_data.data)
  end

  def test_filename
    assert_equal('2.jpg', pictures(:pictures_1).filename)
    assert_equal('1.gif', pictures(:pictures_2).filename)
  end
end
