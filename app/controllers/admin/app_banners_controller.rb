class Admin::AppBannersController < Admin::AdminController
  before_action :authenticate_user!
  before_action :set_app_banner, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
    @appBanners = AppBanner.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
  end

  def new
    @appBanner = AppBanner.new
  end

  def edit
  end

  def create
    @appBanner = AppBanner.new(app_banner_params)
    if @appBanner.save
      redirect_to admin_app_banners_path, notice: "AppBanner was successfully created."
    else
      render :new
    end
  end

  def update
    if @appBanner.update(app_banner_params)
      redirect_to admin_app_banners_path, notice: "AppBanner was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @appBanner.destroy
    redirect_to admin_app_banners_path, notice: "AppBanner was successfully destroyed."
  end

  private

  def set_app_banner
    @appBanner = AppBanner.find(params[:id])
  end

  def app_banner_params
    params.require(:app_banner).permit(:title, :image_url, :action_url, :status)
  end
end
