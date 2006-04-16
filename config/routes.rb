ActionController::Routing::Routes.draw do |map|
  map.connect 'account/:action', :controller => 'account'
  map.connect 'admin', :controller => 'album', :action => 'list'
  map.connect 'admin/album/:action/:id', :controller => 'album'
  map.connect 'admin/picture/:action/:id', :controller => 'picture'
  map.connect ':user/:album/images/:size/:picture', :controller => 'gallery', :action => 'show_image', :requirements => {:picture => /\d+.\w+/, :size => /thumbnail|large|original/}
  map.connect ':user/:album/:picture', :controller => 'gallery', :action => 'show', :picture => '1'
  map.connect ':user', :controller => 'gallery', :action => 'list'
  map.connect '', :controller => 'gallery', :action => 'user_list'
end
