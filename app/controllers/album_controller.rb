class AlbumController < ApplicationController
  verify :method => :get, :only => %w( list show show_picture )
  session :off
  caches_page :list, :show, :show_picture, :show_image

  def list
    @user = find_user
    @album_pages, @albums = paginate(:albums, 
                                     :conditions => ['user_id = ?', @user.id],
                                     :order_by => 'position',
                                     :per_page => 20)
  end

  def show
    @user = find_user
    @album = find_album
    @picture_pages, @pictures = paginate(:pictures, 
                                         :conditions => ['album_id = ?', @album.id],
                                         :order_by => 'position',
                                         :per_page => 20)
  end

  def show_picture
    @user = find_user
    @album = find_album
    @picture = find_picture
  end

  def show_image
    @user = find_user
    @album = find_album
    @picture = find_picture
    send_data(@picture.picture_data.data, 
              :filename => @picture.filename,
	      :type => @picture.picture_data.content_type,
	      :disposition => 'inline')
  end

  protected

  def protect?; false; end

  private 
  
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

  def find_picture
    picture = @album.pictures[params[:picture].gsub(/\.\w+$/,'').to_i - 1]
    raise ActiveRecord::RecordNotFound, "Couldn't find Picture with position = #{params[:picture]} AND album.permalink = #{params[:album]} AND user.name = #{params[:user]}" unless picture
    picture
  end
  
end
