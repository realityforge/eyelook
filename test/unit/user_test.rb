require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_basic_load
    u = users(:users_1)
    assert_not_nil u
    assert_kind_of User, u
    assert_equal u.id, 1
    assert_equal u.name, 'peter'
    assert_equal u.salt, 'MyMostMagicSaltiness'
    assert_equal u['password'], Digest::SHA1.hexdigest("--MyMostMagicSaltiness--retep--")
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
    password = 'secret'
    user = User.new
    user.name = 'bob'
    user.password = password
    assert user.password_matches?(password)
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
