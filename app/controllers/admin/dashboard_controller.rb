module Admin
  class DashboardController < Admin::AdminController
    before_action :authenticate_user!
    layout "admin"

    def index
      @users = User.count
      @offers = Offer.count
      @payouts = Payout.count
    end
  end
end
