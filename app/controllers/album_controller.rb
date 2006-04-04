class AlbumController < ApplicationController
  verify :method => :get, :only => %w( list )

  def list
    @user = User.find(:first, :conditions => ['name = ?', params[:user]])
    raise ActiveRecord::RecordNotFound, "Couldn't find User with name = #{params[:user]}" unless @user
    @album_pages, @albums = paginate(:albums, 
                                     :conditions => ['user_id = ?', @user.id],
                                     :order_by => 'position',
                                     :per_page => 20)
  end

  def show
    @user = User.find(:first, :conditions => ['name = ?', params[:user]])
    raise ActiveRecord::RecordNotFound, "Couldn't find User with name = #{params[:user]}" unless @user
    @album = @user.albums.find(:first, :conditions => ['permalink = ?', params[:album]])
    raise ActiveRecord::RecordNotFound, "Couldn't find Album with permalink = #{params[:album]} AND user name = #{params[:user]}" unless @album
    @picture_pages, @pictures = paginate(:pictures, 
                                         :conditions => ['album_id = ?', @album.id],
                                         :order_by => 'position',
                                         :per_page => 20)
  end

  def show_picture
    @user = User.find(:first, :conditions => ['name = ?', params[:user]])
    raise ActiveRecord::RecordNotFound, "Couldn't find User with name = #{params[:user]}" unless @user
    @album = @user.albums.find(:first, :conditions => ['permalink = ?', params[:album]])
    raise ActiveRecord::RecordNotFound, "Couldn't find Album with permalink = #{params[:album]} AND user.name = #{params[:user]}" unless @album
    logger.debug @album.pictures

    @picture = @album.pictures[params[:picture].to_i]
    raise ActiveRecord::RecordNotFound, "Couldn't find Picture with position = #{params[:picture]} AND album.permalink = #{params[:album]} AND user.name = #{params[:user]}" unless @picture
  end
end
