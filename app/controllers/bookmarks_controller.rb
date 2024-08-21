class BookmarksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    user = User.find_by(id: current_user.id)
    @bookmarks = user.bookmarks
  end

  def show 
    @bookmark = Bookmark.find(params[:id])
    
    # unless current_user.id == @bookmark.user_id
    #   flash[:notice] = "You don't have access to that Bookmark!"
    #   redirect_to user_bookmarks_path
    #   return
    # end

    @info = $flickr.photos.getInfo(photo_id: @bookmark.photo_id)

    respond_to do |f|
      f.html
      f.json { render json: { info: @info, bookmark: @bookmark } }
    end
  end

  def create
    @user = User.find_by(id: current_user.id)
    @bookmark = @user.bookmarks.create(bookmark_params)
    if @bookmark.save
     redirect_to root_path, notice: "Bookmark created successfully!"
    else
     redirect_to root_path, alert: "Error creating bookmark"
    end
  end

  def destroy
    @user = User.find_by(id: current_user.id)
    @bookmark = @user.bookmarks.find(params[:id])
    @bookmark.destroy

    if @bookmark
      @bookmark.destroy
      flash.notice = "Kitten has been destroyed."
      redirect_to root_path
    else
      flash.error = "Bookmark not found."
      redirect_to root_path
    end
  end

  private
  def bookmark_params
    params.require(:bookmark).permit(:flickr_id, :url, :server, :secret, :photo_id)
  end
end
