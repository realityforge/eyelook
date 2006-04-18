class ApplicationController < ActionController::Base
  def access_denied
    redirect_to(:controller=> '/account', :action => 'login')
  end

# protected
#   def rescue_action(e) 
#     redirect_to(:controller => '/security', :action => 'access_denied')
#   end
end
