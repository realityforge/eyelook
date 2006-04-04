ActionController::Routing::Routes.draw do |map|
  map.connect ':user/:album/:picture', :controller => 'album', :action => 'show_picture'
  map.connect ':user/:album', :controller => 'album', :action => 'show'
  map.connect ':user', :controller => 'album', :action => 'list'
  map.connect 'images/:user/:album/:size/:picture', :controller => 'picture', :action => 'show'
end
