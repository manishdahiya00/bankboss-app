module API
  module V1
    class Appuser < Grape::API
      include API::V1::Defaults

      resource :home do
        before { api_params }
        params do
          use :common_params
        end
        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            amount = [3582, 8128, 9529, 5634, 8621, 2698, 4797, 7646, 8499]
            percentage = [2.8, 5.4, 6, 7, 8, 9, 10, 11, 12, 7.5, 6.2, 4.6, 4, 2]
            views = [10, 12, 25, 23, 5, 18, 19, 20, 35]
            app_banners = []
            related_videos = []
            Video.active.limit(6).each do |video|
              related_videos << {
                id: video.id,
                views: "#{views.sample.to_s}00 K+",
                url: video.video_url,
              }
            end
            AppBanner.active.each do |app_banner|
              app_banners << {
                imageUrl: app_banner.image_url,
                actionUrl: app_banner.action_url,
              }
            end
            { status: 200, message: MSG_SUCCESS, walletBalance: user.wallet_balance.to_s, totalEarning: user.transaction_histories.where(status: "COMPLETED").map { |t| t.amount.to_f }.sum, bank: amount.sample.to_s, creditCards: amount.sample.to_s, dematAcc: amount.sample.to_s, personalLoans: percentage.sample.to_s, mutualFunds: amount.sample.to_s, creditLine: percentage.sample.to_s, business: percentage.sample.to_s, homeLoan: percentage.sample.to_s, itr: percentage.sample.to_s, appBanners: app_banners || [], relatedVideos: related_videos || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-home-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR }
          end
        end
      end

      resource :offerList do
        before { api_params }

        params do
          use :common_params
          requires :listCode, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            data = []
            offer_types = [
              "Credit Card",
              "Bank Account",
              "Demat Account",
              "Credit Line",
              "Mutual Fund",
              "Personal Loan",
              "Business Loan",
              "ITR",
              "Home Loan",
            ]

            if params[:listCode].to_i.between?(0, offer_types.length - 1)
              offers = Offer.active.where(offer_type: offer_types[params[:listCode].to_i])
              offers.each do |offer|
                data << {
                  id: offer.id,
                  tag: offer_types[params[:listCode].to_i],
                  offerName: offer.offer_name,
                  offerAmt: offer.offer_amount,
                  imgUrl: offer.icon_small_img_url,
                  description: offer.description,
                }
              end
            end

            { status: 200, message: MSG_SUCCESS, data: data || [] }
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
            ratings = [9.2, 9.1, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 8.6, 8.7, 8.8, 8.9]
            { status: 200, message: MSG_SUCCESS, category: offer.offer_type, desc: offer.description, imgUrl: offer.banner_big_img_url, title: offer.offer_name, amount: offer.offer_amount, videoUrl: offer.yt_video_url, features: offer.features, fees_and_charges: offer.fees_and_charges, target_audience: offer.target_audience, documents_required: offer.documents_required, how_to_get_commission: offer.how_to_get_commission, lead_tracking_time: offer.lead_tracking_time, how_it_works: offer.offer_docs, rules_to_follow: offer.offer_terms, date: offer.created_at.strftime("%d/%m/%y"), ratings: ratings.sample.to_s }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-offerDetail-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :videoDetail do
        before { api_params }

        params do
          use :common_params
          requires :videoId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            video = Video.active.find_by(id: params[:videoId])
            return { status: 500, message: "Video Not Found" } unless video.present?
            ratings = [9.2, 9.1, 9.3, 9.4, 9.5, 9.6, 9.7, 9.8, 9.9, 8.6, 8.7, 8.8, 8.9]
            { status: 200, message: MSG_SUCCESS, desc: video.description, title: video.title, subtitle: video.subtitle, date: video.created_at.strftime("%d/%m/%Y"), videoUrl: video.video_url, rating: ratings.sample.to_s }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-videoDetail-#{params.inspect}-Error-#{e}"
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
            { status: 200, message: MSG_SUCCESS, actionType: "redirect", shareUrl: "https://bankboss.app/leads?t=#{user.refer_code}&o=#{offer.id}", content: "Your #{offer.offer_name} is ready in minutes!\n✔️Get Account Number of Your Choice.\n✔️Up to 6.75% Rate of Interest on Savings Account\n.✔️Earn up to 7.75% interest p.a. with #{offer.offer_name}\n✔️Easy WhatsApp Banking Services.\n✔️Get Discounts on Food, Cab and Bills.\n\nApply now: ", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRllt133YN3tniF_D3kOCexKFhuyY9RKLAlAQ&s" }
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
            { status: 200, message: MSG_SUCCESS, currency: "USD", inviteAmount: 10, inviteFbUrl: "https://bankboss.app/invite", inviteHeading: "Share, Invite friends and get free cash. Get 5 BankBoss amount instant as your friend register on BankBoss App", inviteImgurl: "http://example.com/invite-image.jpg", inviteText: ["Join us and earn rewards", "Invite your friends and get $10 for each signup"], inviteTextUrl: "https://bankboss.app/invite", referralCode: user.refer_code, userBalance: user.wallet_balance }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-appInvite-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :profile do
        before { api_params }

        params do
          use :common_params
          requires :method, type: String, allow_blank: false # GET => SHOWPROFILE, POST => UPDATEPROFILE
          requires :name, type: String, allow_blank: true
          requires :phone, type: String, allow_blank: true
          requires :pincode, type: String, allow_blank: true
          requires :gender, type: String, allow_blank: true
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            isVerified = KycDetail.find_by(user_id: user.id).present?
            if params[:method] == "GET"
              { status: 200, message: MSG_SUCCESS, userName: user.social_name, userEmail: user.social_email, verifyStatus: isVerified ? "VERIFIED" : "NOT VERIFIED", walletBalance: user.wallet_balance, userImage: user.social_img_url, phone: user.mobile_number, pincode: user.pincode, gender: user.gender }
            else
              name = params[:name].presence || user.social_name
              phone = params[:phone].presence || user.mobile_number
              pincode = params[:pincode].presence || user.pincode
              gender = params[:gender].presence || user.gender
              user.update(social_name: name, mobile_number: phone, pincode: pincode, gender: gender)
              { status: 200, message: MSG_SUCCESS, userName: user.social_name, userEmail: user.social_email, verifyStatus: isVerified ? "VERIFIED" : "NOT VERIFIED", walletBalance: user.wallet_balance, userImage: user.social_img_url, phone: user.mobile_number, pincode: user.pincode, gender: user.gender }
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-profile-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :leads do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            successLeads = []
            processingLeads = []
            rejectedLeads = []
            puts user.leads.success
            puts user.leads.processing
            puts user.leads.rejected
            user.leads.success.each do |lead|
              offer = Offer.find_by(id: lead.offer_id)
              successLeads << {
                offerName: offer.offer_name, offerImage: offer.banner_big_img_url, mobileNumber: lead.mobile_number, joiningDate: lead.created_at.strftime("%d/%m/%y"), lastUpdate: lead.updated_at.strftime("%d/%m/%y"), nextUpdate: (lead.updated_at + 7.days).strftime("%d/%m/%y"), payout: offer.offer_amount, shareUrl: "https://bankboss.app/leads?t=#{user.refer_code}&o=#{offer.id}", content: "Your #{offer.offer_name} is ready in minutes!\n✔️Get Account Number of Your Choice.\n✔️Up to 6.75% Rate of Interest on Savings Account\n.✔️Earn up to 7.75% interest p.a. with #{offer.offer_name}\n✔️Easy WhatsApp Banking Services.\n✔️Get Discounts on Food, Cab and Bills.\n\nApply now: ", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRllt133YN3tniF_D3kOCexKFhuyY9RKLAlAQ&s", statusTitle: "Success", statusSubtitle: "Lead is successfully verified.",
              }
            end
            user.leads.processing.each do |lead|
              offer = Offer.find_by(id: lead.offer_id)
              processingLeads << {
                offerName: offer.offer_name, offerImage: offer.banner_big_img_url, mobileNumber: lead.mobile_number, joiningDate: lead.created_at.strftime("%d/%m/%y"), lastUpdate: lead.updated_at.strftime("%d/%m/%y"), nextUpdate: (lead.updated_at + 7.days).strftime("%d/%m/%y"), payout: offer.offer_amount, shareUrl: "https://bankboss.app/leads?t=#{user.refer_code}&o=#{offer.id}", content: "Your #{offer.offer_name} is ready in minutes!\n✔️Get Account Number of Your Choice.\n✔️Up to 6.75% Rate of Interest on Savings Account\n.✔️Earn up to 7.75% interest p.a. with #{offer.offer_name}\n✔️Easy WhatsApp Banking Services.\n✔️Get Discounts on Food, Cab and Bills.\n\nApply now: ", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRllt133YN3tniF_D3kOCexKFhuyY9RKLAlAQ&s", statusTitle: "In Progress", statusSubtitle: "Lead is successfully added and will be updated within 7 days.",
              }
            end
            user.leads.rejected.each do |lead|
              offer = Offer.find_by(id: lead.offer_id)
              rejectedLeads << {
                offerName: offer.offer_name, offerImage: offer.banner_big_img_url, mobileNumber: lead.mobile_number, joiningDate: lead.created_at.strftime("%d/%m/%y"), lastUpdate: lead.updated_at.strftime("%d/%m/%y"), nextUpdate: (lead.updated_at + 7.days).strftime("%d/%m/%y"), payout: offer.offer_amount, shareUrl: "https://bankboss.app/leads?t=#{user.refer_code}&o=#{offer.id}", content: "Your #{offer.offer_name} is ready in minutes!\n✔️Get Account Number of Your Choice.\n✔️Up to 6.75% Rate of Interest on Savings Account\n.✔️Earn up to 7.75% interest p.a. with #{offer.offer_name}\n✔️Easy WhatsApp Banking Services.\n✔️Get Discounts on Food, Cab and Bills.\n\nApply now: ", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRllt133YN3tniF_D3kOCexKFhuyY9RKLAlAQ&s", statusTitle: "Rejected", statusSubtitle: "Your lead is rejected.",
              }
            end
            { status: 200, message: MSG_SUCCESS, totalLeadsCount: user.leads.count, successLeadsCount: user.leads.success.count, progressLeadsCount: user.leads.processing.count, rejectedLeadsCount: user.leads.rejected.count, successLeads: successLeads || [], processingLeads: processingLeads || [], rejectedLeads: rejectedLeads || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-leads-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :kycDetails do
        before { api_params }

        params do
          use :common_params
          requires :method, type: String, allow_blank: false # GET => SHOW KYC DETAIL , POST => UPDATE KYC DETAIL
          requires :aadharNumber, type: String, allow_blank: true
          requires :panNumber, type: String, allow_blank: true
          requires :fullName, type: String, allow_blank: true
          requires :dob, type: String, allow_blank: true
          requires :address, type: String, allow_blank: true
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            if params[:method] == "GET"
              kyc_detail = KycDetail.find_by(user_id: user.id)
              { status: 200, message: MSG_SUCCESS, aadharNumber: kyc_detail.aadhar_number, panNumber: kyc_detail.pan_number, address: kyc_detail.address, fullName: kyc_detail.full_name, dob: kyc_detail.dob }
            else
              kyc_detail = KycDetail.create(user_id: user.id, aadhar_number: params[:aadharNumber], pan_number: params[:panNumber], address: params[:address], full_name: params[:fullName], dob: params[:dob])
              { status: 200, message: MSG_SUCCESS, aadharNumber: kyc_detail.aadhar_number, panNumber: kyc_detail.pan_number, address: kyc_detail.address, fullName: kyc_detail.full_name, dob: kyc_detail.dob }
            end
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-kycDetails-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
