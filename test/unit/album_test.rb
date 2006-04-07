require File.dirname(__FILE__) + '/../test_helper'

class AlbumTest < Test::Unit::TestCase

  def test_basic_load
    assert_kind_of Album, albums(:albums_1)
    assert_equal 1, albums(:albums_1).id
    assert_equal 1, albums(:albums_1).user_id
    assert_equal 'climbing_with_crazy_canadians', albums(:albums_1).permalink
    assert_equal 'Climbing with the Crazy Canadians', albums(:albums_1).caption
    assert_equal 'One upon a time I met a crazy canadian who was more buff than me and ... climbing is fun.', albums(:albums_1).description
    assert_equal 2, albums(:albums_1).position
    assert_not_nil albums(:albums_1).created_at
    assert_not_nil albums(:albums_1).updated_at
    assert_nil albums(:albums_1).lower_item
    assert_not_nil albums(:albums_1).higher_item
    assert_equal 1, albums(:albums_1).higher_item.position
    assert_equal 1, albums(:albums_1).user.id

    assert_equal 15, albums(:albums_1).pictures.size
    assert_equal 1, albums(:albums_1).pictures[0].position
    assert_equal 2, albums(:albums_1).pictures[0].id
    assert_equal 2, albums(:albums_1).pictures[1].position
    assert_equal 1, albums(:albums_1).pictures[1].id

    assert_equal 2, albums(:albums_1).tag_names.size
    assert albums(:albums_1).tag_names.include?('happy')
    assert albums(:albums_1).tag_names.include?('sad')
  end

  def test_save_with_nil_user
    album = Album.new
    album.user_id = nil
    album.permalink = 'eyecandy'
    album.caption = 'Eyecandy'
    album.description = 'Check this out!'
    assert_equal false, album.save
    assert_not_nil album.errors['user_id']
  end

  def test_save_with_bad_caption
    album = Album.new
    album.user_id = 1
    album.permalink = 'eyecandy'
    album.caption = ''
    album.description = 'Check this out!'
    assert_equal false, album.save
    assert_not_nil album.errors['caption']
  end

  def test_save_with_bad_permalink
    album = Album.new
    album.user_id = 1
    album.permalink = ''
    album.caption = 'Eyecandy'
    album.description = 'Check this out!'
    assert_equal false, album.save
    assert_not_nil album.errors['permalink']
  end

  def test_save
    album = Album.new
    album.user_id = 1
    album.permalink = 'eyecandy'
    album.caption = 'Eyecandy'
    album.description = 'Check this out!'
    assert_equal true, album.save
    album.reload

    assert_kind_of Album, album
    assert_equal 1, album.user_id
    assert_equal 'eyecandy', album.permalink
    assert_equal 'Eyecandy', album.caption
    assert_equal 'Check this out!', album.description
    assert_not_nil album.created_at
    assert_not_nil album.updated_at
    assert_equal 3, album.position
    assert_nil album.lower_item
    assert_not_nil album.higher_item
    assert_equal 2, album.higher_item.position
    assert_equal 1, album.higher_item.id
    assert_equal 1, album.user.id
  end
end
