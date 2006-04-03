require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  def test_basic_load
    assert_not_nil users(:users_1)
    assert_kind_of User, users(:users_1)
    assert_equal 1, users(:users_1).id
    assert_equal 'peter', users(:users_1).name
    assert_equal 'MyMostMagicSaltiness', users(:users_1).salt
    assert_equal Digest::SHA1.hexdigest("--MyMostMagicSaltiness--retep--"), users(:users_1)['password']
    assert_equal 2, users(:users_1).albums.size
    assert_equal 1, users(:users_1).albums[0].position
    assert_equal 2, users(:users_1).albums[1].position
  end

  def test_authenticate
    assert_not_nil User.authenticate('peter','retep')
  end

  def test_authenticate_bad_password
    assert_nil User.authenticate('peter','bad_password')
  end

  def test_authenticate_missing_user
    assert_nil User.authenticate('bob','bad_password')
  end

  def test_password_write
    user = User.new
    user.name = 'bob'
    user.password = 'secret'
    assert user.password_matches?('secret')
    assert_not_nil user['salt']
  end

  def test_password_read
    assert_equal '', users(:users_1).password
  end

  def test_password_matches?
    assert_equal true, users(:users_1).password_matches?('retep')
    assert_equal false, users(:users_1).password_matches?('bad_password')
  end
end
