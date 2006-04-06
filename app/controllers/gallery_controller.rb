class GalleryController < ApplicationController
  verify :method => :get, :only => %w( user_list list show show_picture show_image )
  session :off
  caches_page :user_list, :list, :show, :show_picture, :show_image

  def user_list
    @user_pages, @users = paginate(:users, 
                                   :order_by => 'name',
                                   :per_page => 20)
  end

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
    disposition = (params[:disposition] == 'download') ? 'download' : 'inline'
    @user = find_user
    @album = find_album
    @picture = find_picture
    if params[:size] == 'original'
      send_data(@picture.picture_data.data, 
                :filename => "#{@album.permalink}_#{@picture.filename}",
                :type => @picture.content_type,
                :disposition => disposition)
    else
      geometry = @@geometry[params[:size]]
      if geometry.nil?
        render :text => "Arbitrary image geometry not currently implemented.", :status => 501
      else
        image = Magick::Image.from_blob(@picture.picture_data.data).first
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

  @@geometry = {'large' => '400x400', 'thumbnail' => '90x90'}
  
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
