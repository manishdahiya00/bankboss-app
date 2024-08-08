class Admin::VideosController < Admin::AdminController
  before_action :authenticate_user!
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
    @videos = Video.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
  end

  def new
    @video = Video.new
  end

  def edit
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to admin_videos_path, notice: "Video was successfully created."
    else
      render :new
    end
  end

  def update
    if @video.update(video_params)
      redirect_to admin_videos_path, notice: "Video was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to admin_videos_path, notice: "Video was successfully destroyed."
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:video_url, :title, :subtitle, :description, :status)
  end
end
