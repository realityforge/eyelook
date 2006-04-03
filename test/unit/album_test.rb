require File.dirname(__FILE__) + '/../test_helper'

class AlbumTest < Test::Unit::TestCase
  fixtures :users, :albums

  def test_basic_load
    assert_kind_of Album, albums(:albums_1)
    assert_equal 1, albums(:albums_1).id
    assert_equal 1, albums(:albums_1).user_id
    assert_equal 'Climbing with the Crazy Canadians', albums(:albums_1).name
    assert_equal 'One upon a time I met a crazy canadian who was more buff than me and ... climbing is fun.', albums(:albums_1).description
    assert_equal 1, albums(:albums_1).position
    assert_not_nil albums(:albums_1).created_at
    assert_not_nil albums(:albums_1).updated_at
    assert_nil albums(:albums_1).higher_item
    assert_not_nil albums(:albums_1).lower_item
    assert_equal 2, albums(:albums_1).lower_item.position
    assert_equal 1, albums(:albums_1).user.id
  end

  def test_save_with_nil_user
    album = Album.new
    album.user_id = nil
    album.name = 'Eyecandy'
    album.description = 'Check this out!'
    assert_equal false, album.save
    assert_not_nil album.errors['user_id']
  end

  def test_save_with_bad_name
    album = Album.new
    album.user_id = 1
    album.name = ''
    album.description = 'Check this out!'
    assert_equal false, album.save
    assert_not_nil album.errors['name']
  end

  def test_save
    album = Album.new
    album.user_id = 1
    album.name = 'Eyecandy'
    album.description = 'Check this out!'
    assert_equal true, album.save
    album.reload

    assert_kind_of Album, album
    assert_equal 1, album.user_id
    assert_equal 'Eyecandy', album.name
    assert_equal 'Check this out!', album.description
    assert_not_nil album.created_at
    assert_not_nil album.updated_at
    assert_equal 3, album.position
    assert_nil album.lower_item
    assert_not_nil album.higher_item
    assert_equal 2, album.higher_item.position
    assert_equal 2, album.higher_item.id
    assert_equal 1, album.user.id
  end
end
