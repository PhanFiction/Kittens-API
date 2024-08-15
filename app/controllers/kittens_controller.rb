require 'rest-client'

class KittensController < ApplicationController
  def index
    @kittens = Kitten.all
    @list = $flickr.photos.search(tags: "cat")

    puts "Kitten is #{@list}"

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

  def new
    @kitten = Kitten.new
  end

  def create
    @kitten = Kitten.new(kitten_params)

    if @kitten.save
      flash.notice = "Your new kitten joined the litter!"
      redirect_to @kitten
    else
      flash.alert = "Unable to add kitten. Fill out all fields and try again."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @kitten = Kitten.find(params[:id])
    @kitten = $flickr.photos.getInfo(photo_id: params[:id])
    p "URL is #{@kitten.urls.url}"
    respond_to do |f|
      f.html
      f.json { render json: @kitten }
    end
  end

  def edit
    @kitten = Kitten.find(params[:id])
  end

  def update
    @kitten = Kitten.find(params[:id])

    if @kitten.update(kitten_params)
      flash.notice = "Your kitten rejoined the litter!"
      redirect_to @kitten
    else
      flash.alert = "Unable to change kitten. Fill out all fields and try again."
      render :edit, status: :unprocessable_entity
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
    params.require(:kitten).permit(:name, :age, :cuteness, :softness)
  end
end
