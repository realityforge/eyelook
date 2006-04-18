class PictureSweeper < ActionController::Caching::Sweeper
  observe Picture

  def after_save(picture)
    ['thumbnail','large','original'].each do |size|
      expire_page(:controller => 'gallery', 
                  :action => 'show_image', 
                  :size => size, 
                  :image => picture.filename)
    end
  end

  alias :after_destroy :after_save
end
