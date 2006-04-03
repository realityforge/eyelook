require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase

  def test_basic_load
    assert_kind_of Tag, tags(:tags_1)
    assert_equal 1, tags(:tags_1).id
    assert_equal 'happy', tags(:tags_1).name
  end

  def test_save_with_bad_name
    tag = Tag.new
    tag.name = ''
    assert_equal false, tag.save
    assert_not_nil tag.errors['name']
  end

  def test_save_with_duplicate_name
    assert_not_nil Tag.find_by_name('happy')
    tag = Tag.new
    tag.name = 'happy'
    assert_equal false, tag.save
    assert_not_nil tag.errors['name']
  end

  def test_save
    tag = Tag.new
    tag.name = 'Eyecandy'
    assert_equal true, tag.save
    tag.reload
    assert_kind_of Tag, tag
    assert_equal 'Eyecandy', tag.name
  end
end
