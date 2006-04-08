require File.dirname(__FILE__) + '/../test_helper'
require 'gallery_controller'

# Re-raise errors caught by the controller.
class GalleryController; def rescue_action(e) raise e end; end

class GalleryControllerTest < Test::Unit::TestCase
  def setup
    @controller = GalleryController.new
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
    get(:show, {:user => 'peter', :album => 'climbing_with_crazy_canadians', :picture => '3'}, {})
    assert_response(:success)
    assert_template('show')
    assert_valid_markup
    assert_not_nil(assigns(:user))
    assert_not_nil(assigns(:album))
    assert_not_nil(assigns(:picture))
    assert_not_nil(assigns(:pictures))
    assert_not_nil(assigns(:picture_pages))
    assert_equal(users(:users_1).id,assigns(:user).id)
    assert_equal(albums(:albums_1).id,assigns(:album).id)
    assert_equal(pictures(:pictures_3).id,assigns(:picture).id)
    assert_equal(9,assigns(:pictures).length)
    assert_equal(pictures(:pictures_2).id,assigns(:pictures)[0].id)
    assert_equal(pictures(:pictures_1).id,assigns(:pictures)[1].id)
    assert_equal(pictures(:pictures_3).id,assigns(:pictures)[2].id)
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

  def test_show_with_bad_picture
    assert_raises(ActiveRecord::RecordNotFound,"Couldn't find Picture with position = 21 AND album.permalink = climbing_with_crazy_canadians AND user.name = peter") do
      get(:show, {:user => 'peter', :album => 'climbing_with_crazy_canadians', :picture => '21'}, {})
    end
  end
end
