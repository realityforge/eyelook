class AlbumController < ApplicationController
  verify :method => :post, :only => %w( destroy move_first move_up move_down move_last )
  verify :method => :get, :only => %w( show list )

  def list
    @album_pages, @albums = 
      paginate(:albums, 
               :conditions => ['user_id = ?', current_user.id],
               :order_by => 'position',
               :per_page => 10)
  end
  
  def new
    @album = Album.new(params[:album])
    if request.post?
      @album.user_id = current_user.id
      if @album.save
        flash[:notice] = 'Album was successfully created.'
        redirect_to(:action => 'show', :id => @album)
      end
    end
  end
  
  def show
    @album = current_user.albums.find(params[:id])
  end

  def edit
    @album = current_user.albums.find(params[:id])
    if request.post?
      if @album.update_attributes(params[:album])
        flash[:notice] = 'Album was successfully updated.'
        redirect_to(:action => 'show', :id => @album)
      end
    end
  end

  def destroy
    current_user.albums.find(params[:id]).destroy
    flash[:notice] = 'Album was successfully deleted.'
    redirect_to_list
  end

  def move_first
    album = current_user.albums.find(params[:id])
    album.move_to_top
    redirect_to_list
  end

  def move_up
    album = current_user.albums.find(params[:id])
    album.move_higher
    redirect_to_list
  end

  def move_down
    album = current_user.albums.find(params[:id])
    album.move_lower
    redirect_to_list
  end

  def move_last
    album = current_user.albums.find(params[:id])
    album.move_to_bottom
    redirect_to_list
  end

private
  def redirect_to_list
    redirect_to(:action => 'list', :page => params[:page])
  end
end
