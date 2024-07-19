module API
  module V1
    class Appuser < Grape::API
      include API::V1::Defaults

      resource :offerList do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?

            offer_types = {
              "Credit Card" => :creditList,
              "Debit Card" => :dematList,
              "Saving Account" => :savingList,
              "Mutual Fund" => :mutualFunds,
            }

            offer_data = offer_types.each_with_object({}) do |(type, key), hash|
              offers = Offer.active.where(offer_type: type)
              hash[key] = offers.map do |offer|
                { id: offer.id, offerName: offer.offer_name, offerAmt: offer.offer_amount, description: offer.description, imgUrl: offer.icon_small_img_url }
              end
            end
            { status: 200, message: MSG_SUCCESS }.merge(offer_data)
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-offerList-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :offerDetail do
        before { api_params }

        params do
          use :common_params
          requires :offerId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            offer = Offer.active.find_by(id: params[:offerId])
            return { status: 500, message: "Offer Not Found" } unless offer.present?

            { status: 200, message: MSG_SUCCESS, desc: offer.description, howTo: offer.offer_docs, imgUrl: offer.banner_big_img_url, title: offer.offer_name, amount: offer.offer_amount, videoUrl: offer.yt_video_url }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-offerDetail-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :trendingOffer do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            trendingOffers = []
            offers = Offer.active.where(priority: "1")
            offers.each do |offer|
              trendingOffers << { id: offer.id, offerName: offer.offer_name, offerAmt: offer.offer_amount, description: offer.description, imgUrl: offer.icon_small_img_url, offerType: offer.offer_type }
            end
            { status: 200, message: MSG_SUCCESS, trendingOffer: trendingOffers || [], userBalance: user.wallet_balance }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-offerDetail-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :offerClicked do
        before { api_params }

        params do
          use :common_params
          requires :offerId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            offer = Offer.active.find_by(id: params[:offerId])
            return { status: 500, message: "Offer Not Found" } unless offer.present?
            { status: 200, message: MSG_SUCCESS, actionType: "redirect", actionUrl: offer.action_url }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-offerClicked-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :appNotification do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            notificationsList = []
            notifications = Offer.active.limit(10)
            notifications.each do |notification|
              notificationsList << { desc: notification.description, offerDate: notification.created_at.strftime("%d/%m/%y"), offerId: notification.id, offerImg: notification.icon_small_img_url, offerTime: notification.created_at.strftime("%I:%M %p"), title: notification.offer_name }
            end
            { status: 200, message: MSG_SUCCESS, notifications: notificationsList }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-appNotifications-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :appInvite do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            { status: 200, message: MSG_SUCCESS, currency: "USD", inviteAmount: 10, inviteFbUrl: "http://example.com/invite-fb", inviteHeading: "Share, Invite friends and get free cash. Get 5 BankBoss amount instant as your friend register on BankBoss App", inviteImgurl: "http://example.com/invite-image.jpg", inviteText: ["Join us and earn rewards", "Invite your friends and get $10 for each signup"], inviteTextUrl: "http://example.com/invite-text", referralCode: user.refer_code, userBalance: user.wallet_balance }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-appInvite-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
