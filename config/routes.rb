ActionController::Routing::Routes.draw do |map|
  map.connect ':user/:album/:size/:picture', :controller => 'gallery', :action => 'show_image', :requirements => {:picture => /\d+.\w+/, :size => /thumbnail|large|original/}
  map.connect ':user/:album/:picture', :controller => 'gallery', :action => 'show_image', :size => 'original', :requirements => {:picture => /\d+.\w+/}
  map.connect ':user/:album/:picture', :controller => 'gallery', :action => 'show_picture'
  map.connect ':user/:album', :controller => 'gallery', :action => 'show'
  map.connect ':user', :controller => 'gallery', :action => 'list'
  map.connect '', :controller => 'gallery', :action => 'user_list'
end
