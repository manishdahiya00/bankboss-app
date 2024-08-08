class Admin::OffersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @offers = Offer.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers_path, notice: "Coupon offer was successfully created."
    else
      render :new
    end
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])
    if @offer.update(offer_params)
      redirect_to admin_offers_path, notice: "Offer was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy
    redirect_to admin_offers_path, notice: "Offer was successfully destroyed."
  end

  private

  def offer_params
    params.require(:offer).permit(
      :offer_name, :description, :status, :offer_type, :offer_rate, :offer_time,
      :offer_tags, :fee_charge, :offer_amount, :income_amount, :short_text, :priority, :yt_video_url,
      :icon_small_img_url, :banner_big_img_url, :action_url, :offer_docs, :offer_terms, :features, :fees_and_charges, :target_audience, :documents_required, :how_to_get_commission, :lead_tracking_time
    )
  end
end
