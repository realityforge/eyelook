class ApplicationController < ActionController::Base
 def access_denied
   redirect_to(:controller=> '/account', :action => 'login')
 end 
end
