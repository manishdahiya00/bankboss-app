class AcdeleteController < ApplicationController
  def new
    @deleted_user = DeletedUser.new
  end

  def create
    @user = User.find_by(social_email: user_params[:email])
    if @user.present?
      @existing_deleted_user = DeletedUser.find_by(email: user_params[:email])
      if @existing_deleted_user.present?
        flash[:alert] = "User deletion request already sent."
        redirect_to "/acdelete"
      else
        @deleted_user = DeletedUser.new(user_params)
        if @deleted_user.save
          flash[:alert] = "User deletion request submitted successfully"
          redirect_to "/acdelete"
        else
          flash[:alert] = @deleted_user.errors.full_messages.to_sentence
          redirect_to "/acdelete"
        end
      end
    else
      flash[:alert] = "No user associated with this email address"
      redirect_to "/acdelete"
    end
  end

  private

  def user_params
    params.require(:deleted_user).permit(:email)
  end
end
