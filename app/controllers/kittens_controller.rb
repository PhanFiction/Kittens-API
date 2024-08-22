class KittensController < ApplicationController

  def index
    @kittens = Kitten.all
    query = params[:query].nil? ? "cats" : params[:query]
    @list = $flickr.photos.search(tags: query)

    # Example data from flickr when searching photo
    # {
    #   "id": "53922189201",
    #   "owner": "198964021@N08",
    #   "secret": "446b3dd1da",
    #   "server": "65535",
    #   "farm": 66,
    #   "title": "Studying with my cat",
    #   "ispublic": 1,
    #   "isfriend": 0,
    #   "isfamily": 0
    # }

    respond_to do |f|
      f.html
      f.json { render json: @list }
    end
  end

  def show
    # @kitten = Kitten.find(params[:id])
    @info = $flickr.photos.getInfo(photo_id: params[:id])
    respond_to do |f|
      f.html
      f.json { render json: @info }
    end
  end

  def destroy
    @kitten = Kitten.find(params[:id])
    @kitten.destroy
    flash.notice = "Kitten has been destroyed."
    redirect_to root_path
  end

  private
  def kitten_params
    params.require(:kitten).permit(:name)
  end
end
