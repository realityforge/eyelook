require File.dirname(__FILE__) + '/../test_helper'
require 'album_controller'

# Re-raise errors caught by the controller.
class AlbumController; def rescue_action(e) raise e end; end

class AlbumControllerTest < Test::Unit::TestCase
  def setup
    @controller = AlbumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_list
    get(:list, {:user => 'peter'}, {})
    assert_response(:success)
    assert_template('list')
    assert_valid_markup
    assert_not_nil(assigns(:user))
    assert_not_nil(assigns(:albums))
    assert_not_nil(assigns(:album_pages))
    assert_equal(users(:users_1).id,assigns(:user).id)
    assert_equal(2,assigns(:albums).length)
    assert_equal(albums(:albums_2).id,assigns(:albums)[0].id)
    assert_equal(albums(:albums_1).id,assigns(:albums)[1].id)
    assert_nil(flash[:alert])
    assert_nil(flash[:notice])
  end

  def test_list_with_bad_user
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find User with name = not_peter") do
      get(:list, {:user => 'not_peter'}, {}) 
    end
  end

  def test_show
    get(:show, {:user => 'peter', :album => 'climbing_with_crazy_canadians'}, {})
    assert_response(:success)
    assert_template('show')
    assert_valid_markup
    assert_not_nil(assigns(:user))
    assert_not_nil(assigns(:album))
    assert_not_nil(assigns(:pictures))
    assert_not_nil(assigns(:picture_pages))
    assert_equal(users(:users_1).id,assigns(:user).id)
    assert_equal(albums(:albums_1).id,assigns(:album).id)
    assert_equal(2,assigns(:pictures).length)
    assert_equal(pictures(:pictures_2).id,assigns(:pictures)[0].id)
    assert_equal(pictures(:pictures_1).id,assigns(:pictures)[1].id)
    assert_nil(flash[:alert])
    assert_nil(flash[:notice])
  end

  def test_show_with_bad_user
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find User with name = X") do
      get(:show, {:user => 'X', :album => 'climbing_with_crazy_canadians'}, {})
    end
  end

  def test_show_with_bad_album
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find Album with permalink = X AND user name = peter") do
      get(:show, {:user => 'peter', :album => 'X'}, {})
    end
  end

  def test_show_picture
    get(:show_picture, {:user => 'peter', :album => 'climbing_with_crazy_canadians', :picture => 1}, {})
    assert_response(:success)
    assert_template('show_picture')
    assert_valid_markup
    assert_not_nil(assigns(:user))
    assert_not_nil(assigns(:album))
    assert_not_nil(assigns(:picture))
    assert_equal(users(:users_1).id,assigns(:user).id)
    assert_equal(albums(:albums_1).id,assigns(:album).id)
    assert_equal(pictures(:pictures_2).id,assigns(:picture).id)
    assert_nil(flash[:alert])
    assert_nil(flash[:notice])
  end

  def test_show_picture_with_bad_user
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find User with name = X") do
      get(:show_picture, {:user => 'X', :album => 'climbing_with_crazy_canadians', :picture => 1}, {})
    end
  end

  def test_show_picture_with_bad_album
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find Album with permalink = X AND user.name = peter") do
      get(:show_picture, {:user => 'peter', :album => 'X', :picture => 1}, {})
    end
  end

  def test_show_picture_with_bad_picture
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find Picture with position = 21 AND album.permalink = climbing_with_crazy_canadians AND user.name = peter") do
      get(:show_picture, {:user => 'peter', :album => 'climbing_with_crazy_canadians', :picture => 21}, {})
    end
  end

end
