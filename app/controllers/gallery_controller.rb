class GalleryController < ApplicationController
  verify :method => :get, :only => %w( user_list list show show_picture show_image )
  session :off
  caches_page :show_image

  def user_list
    @user_pages, @users = paginate(:users, 
                                   :order_by => 'name',
                                   :per_page => 20)
  end

  def list
    @user = find_user
    sql = "SELECT distinct albums.* FROM albums LEFT JOIN pictures ON pictures.album_id = albums.id WHERE (albums.user_id = #{@user.id}) ORDER BY albums.position"
    @album_pages, @albums = paginate_from_sql(Album, sql, 4)
  end

  def show
    @user = find_user
    @album = find_album
    index = params[:picture].to_i
    @picture = @album.pictures[params[:picture].to_i - 1]
    raise ActiveRecord::RecordNotFound, "Couldn't find Picture with position = #{params[:picture]} AND album.permalink = #{params[:album]} AND user.name = #{params[:user]}" unless @picture

    params[:page] = ((index - 1) / 9) + 1
    @picture_pages, @pictures = paginate(:pictures, 
                                         :conditions => ['album_id = ?', @album.id],
                                         :order_by => 'position',
                                         :per_page => 9)
  end

  def show_image
    @picture = Picture.find(params[:image].gsub(/\.\w+$/,'').to_i)
    if params[:size] == 'original'
      send_data(@picture.picture_data.data, 
                :filename => "#{@picture.filename}",
                :type => @picture.content_type,
                :disposition => 'inline')
    else
      geometry = @@geometry[params[:size]]
      if geometry.nil?
        render :text => "Arbitrary image geometry not currently implemented.", :status => 501
      else
        image = @picture.to_image
        image.change_geometry!(geometry) {|cols,rows,img| img.resize!(cols,rows)}
        send_data(image.to_blob, 
                  :filename => @picture.filename,
                  :type => @picture.content_type,
                  :disposition => 'inline')
      end
    end
  end

  protected

  def protect?; false; end

  private 

  def paginate_from_sql(model, sql, per_page)
    total = model.count_by_sql("SELECT count(*) AS count_all FROM (#{sql}) dummy_table")
    object_pages = Paginator.new(self, total, per_page, params[:page])
    objects = model.find_by_sql("#{sql} LIMIT #{per_page} OFFSET #{object_pages.current.to_sql[1]}")
    return object_pages, objects
  end

  @@geometry = {'large' => '300x300', 'thumbnail' => '100x100'}
  
  def find_user
    user = User.find(:first, :conditions => ['name = ?', params[:user]])
    raise ActiveRecord::RecordNotFound, "Couldn't find User with name = #{params[:user]}" unless user
    user
  end

  def find_album
    album = @user.albums.find(:first, :conditions => ['permalink = ?', params[:album]])
    raise ActiveRecord::RecordNotFound, "Couldn't find Album with permalink = #{params[:album]} AND user.name = #{params[:user]}" unless album
    album
  end
end
