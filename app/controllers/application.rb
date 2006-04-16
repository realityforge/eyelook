class ApplicationController < ActionController::Base
  def access_denied
    redirect_to(:controller=> '/account', :action => 'login')
  end

protected

  def expire_album(album)
    album.pictures.each do |picture|
      ['thumbnail','large','original'].each do |size|
        expire_page(:controller => 'gallery', 
                    :action => 'show_image', 
                    :user => current_user.name, 
                    :album => album.permalink, 
                    :size => size, 
                    :picture => picture.filename)
      end
    end
  end
 
#  def rescue_action(e) 
#    redirect_to(:controller => '/security', :action => 'access_denied')
#  end
end
