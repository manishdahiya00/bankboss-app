class Admin::UsersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @users = User.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @appOpens = @user.app_opens.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
    @transactions = @user.transaction_histories.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
    @kyc = KycDetail.find_by(user_id: @user.id)
    @leads = @user.leads.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  def lead
    @lead = Lead.find_by(id: params[:id])
    @lead.update(status: params[:status])
  end
end
