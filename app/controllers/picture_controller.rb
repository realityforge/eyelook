class PictureController < ApplicationController
  verify :method => :post, :only => %w( destroy move_first move_up move_down move_last )
  verify :method => :get, :only => %w( show list )

  def list
    @album = current_user.albums.find(params[:album_id])
    @picture_pages, @pictures = 
      paginate(:pictures, 
               :conditions => ['album_id = ?', @album.id],
               :order_by => 'position',
               :per_page => 10)
  end
  
  def new
    @picture = Picture.new(params[:picture])
    if request.post?
      if @picture.save
        flash[:notice] = 'Picture was successfully created.'
        redirect_to(:action => 'show', :id => @picture)
      end
    end
  end
  
  def show
    @picture = find_picture(params[:id])
  end

  def edit
    @picture = find_picture(params[:id])
    if request.post?
      if @picture.update_attributes(params[:picture])
        flash[:notice] = 'Picture was successfully updated.'
        redirect_to(:action => 'show', :id => @picture)
      end
    end
  end

  def destroy
    @picture = find_picture(params[:id])
    album_id = @picture.album_id
    @picture.destroy
    flash[:notice] = 'Picture was successfully deleted.'
    redirect_to_list(album_id)
  end

  def move_first
    @picture = find_picture(params[:id])
    @picture.move_to_top
    redirect_to_list
  end

  def move_up
    @picture = find_picture(params[:id])
    @picture.move_higher
    redirect_to_list
  end

  def move_down
    @picture = find_picture(params[:id])
    @picture.move_lower
    redirect_to_list
  end

  def move_last
    @picture = find_picture(params[:id])
    @picture.move_to_bottom
    redirect_to_list
  end

private
  def redirect_to_list(album_id = @picture.album_id)
    redirect_to(:action => 'list', :page => params[:page], :album_id => album_id)
  end

  def find_picture(picture_id)
    picture = Picture.find(picture_id,
                           :select => 'pictures.*',
                           :conditions => [ 'albums.user_id = ?', current_user.id],
                           :joins => 'LEFT OUTER JOIN albums ON albums.id = pictures.album_id',
                           :readonly => false)
    raise ActiveRecord::RecordNotFound, "Couldn't find Picture with id = #{params[:id]} AND user_id = #{current_user.id}" unless picture
    picture
  end
end
