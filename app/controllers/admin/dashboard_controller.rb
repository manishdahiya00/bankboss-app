module Admin
  class DashboardController < Admin::AdminController
    layout "admin"

    def index
      @users = User.count
      @offers = Offer.count
      @payouts = Payout.count
    end
  end
end
