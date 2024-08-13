class MainController < ApplicationController
  def index
  end

  def invite
  end

  def leads
    if request.get?
      if params[:t].present? && !params[:t].blank? && params[:o].present? && !params[:o].blank?
        puts params[:t]
        @user = User.find_by(refer_code: params[:t])
        @offer = Offer.find_by(id: params[:o])
        if @user.present? && @offer.present?
          puts @user
          puts @offer
        else
          redirect_to root_path
        end
      else
        redirect_to root_path
      end
    end
    if request.post?
      @lead = Lead.new(lead_params)
      @offer = Offer.find_by(id: params[:lead][:offer_id])
      @user = User.find_by(id: params[:lead][:user_id])
      @prev_lead = Lead.find_by(user_id: @user.id, offer_id: @offer.id, mobile_number: params[:lead][:mobile_number])
      if @prev_lead.present?
        flash[:alert] = "Already registered for this offer"
      else
        if @lead.save
          redirect_to @offer.action_url, allow_other_host: true
        else
          flash[:alert] = "Something Went Wrong !"
        end
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:pan_number, :full_name, :email_address, :mobile_number, :pincode, :user_id, :offer_id)
  end
end
