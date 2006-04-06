ActionController::Routing::Routes.draw do |map|
  map.connect ':user/:album/:picture', :controller => 'album', :action => 'show_image', :picture => /\d+.\w+/
  map.connect ':user/:album/:picture', :controller => 'album', :action => 'show_picture'
  map.connect ':user/:album', :controller => 'album', :action => 'show'
  map.connect ':user', :controller => 'album', :action => 'list'
end
