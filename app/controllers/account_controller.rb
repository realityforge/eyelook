class AccountController < ApplicationController
  verify :method => :post, :only => %w( logout )

  def login
    if request.post?
      self.current_user = User.authenticate(params[:username], params[:password])
      if current_user
        redirect_back_or_default(:controller => 'album', :action => 'list')
      else 
        flash[:alert] = 'Incorrect Login or Password.'
      end
    end
  end

  def logout
    self.current_user = nil
    flash[:notice] = 'You have been logged out.'
    redirect_to(:controller => 'gallery', :action => 'user_list')
  end

  protected 
  def protect?; false; end
end
