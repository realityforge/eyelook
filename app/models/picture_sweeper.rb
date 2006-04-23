class PictureSweeper < ActionController::Caching::Sweeper
  observe Picture

  def after_destroy(picture)
    ::ImageGeometry.keys.each do |size|
      expire_page(:controller => 'gallery', 
                  :action => 'show_image', 
                  :size => size, 
                  :image => picture.filename)
    end
  end
end
