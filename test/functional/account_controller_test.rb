require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

module ActionController #:nodoc:
  class TestRequest < AbstractRequest #:nodoc:
    def reset_session
      @session.delete
    end
  end
end

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login_get
    get(:login, {}, {})
    assert_response(:success)
    assert_template('login')
    assert_valid_markup
    assert_nil(flash[:alert])
    assert_nil(flash[:notice])
  end

  def test_login_post_success
    post(:login, {:username => 'peter', :password => 'retep'}, {})
    assert_redirected_to(:controller => 'album', :action => 'list')
    assert_nil(flash[:alert])
    assert_nil(flash[:notice])
  end

  def test_login_post_fail
    post(:login, {:username => 'peter', :password => ''}, {})
    assert_response(:success)
    assert_template('login')
    assert_valid_markup
    assert_equal('Incorrect Login or Password.',flash[:alert])
    assert_nil(flash[:notice])
  end

  def test_logout
    post(:logout, {}, {:user_id => users(:users_1).id})
    assert_redirected_to(:controller => 'gallery', :action => 'user_list')
    assert_nil(flash[:alert])
    assert_equal('You have been logged out.',flash[:notice])
  end
end
