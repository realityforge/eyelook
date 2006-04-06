ActionController::Routing::Routes.draw do |map|
  map.connect ':user/:album/:size/:picture', :controller => 'album', :action => 'show_image', :requirements => {:picture => /\d+.\w+/, :size => /thumbnail|large|original/}
  map.connect ':user/:album/:picture', :controller => 'album', :action => 'show_image', :size => 'original', :requirements => {:picture => /\d+.\w+/}
  map.connect ':user/:album/:picture', :controller => 'album', :action => 'show_picture'
  map.connect ':user/:album', :controller => 'album', :action => 'show', :page => '1'
  map.connect ':user', :controller => 'album', :action => 'list', :page => '1'
end
