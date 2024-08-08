module API
  module V1
    class Wallet < Grape::API
      include API::V1::Defaults

      resource :transactionList do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            transactions = []
            pendingTransaction = user.transaction_histories.where(status: "PENDING")
            completedTransaction = user.transaction_histories.where(status: "COMPLETED")
            total_earning = completedTransaction.map { |t| t.amount.to_f }.sum
            user.transaction_histories.order(created_at: :desc).limit(30).each do |transaction|
              transactions << { amount: transaction.amount.to_s, timeAt: transaction.created_at.strftime("%d/%m/%y %I:%M %p"), title: transaction.title || "" }
            end
            { status: 200, message: MSG_SUCCESS, totalEarning: total_earning.to_s, transactions: transactions || [], userBalance: user.wallet_balance, conversion: (user.wallet_balance.to_f / 100).to_s }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-transactionList-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :rewardList do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            rewardList = []
            Payout.all.each do |payout|
              rewardList << {
                payoutId: payout.id,
                imageUrl: payout.img_url,
                payout_reward: payout.reward.split(","),
                payout_value: payout.reward.split(",").map { |coin| (coin.to_f / 100).to_s },
                redeemLimit: payout.redeem_limit,
                rewardType: payout.reward_type,
                title: payout.title,
              }
            end
            { status: 200, message: MSG_SUCCESS, userBalance: user.wallet_balance, conversion: (user.wallet_balance.to_f / 100).to_s, rewardList: rewardList || [] }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-rewardList-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
      resource :redeemSubmit do
        before { api_params }

        params do
          use :common_params
          requires :upiId, type: String, allow_blank: false
          requires :phone, type: String, allow_blank: false
          requires :coins, type: String, allow_blank: false
          requires :coinsValue, type: String, allow_blank: false
          requires :payoutId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            return { status: 500, message: INVALID_USER } unless user.present?
            wallet_balance = user.wallet_balance.to_f - params[:coins].to_f
            return { status: 500, message: "Insufficient Balance" } if user.wallet_balance.to_f < params[:coins].to_f
            user.update(wallet_balance: wallet_balance)
            user.transaction_histories.create(title: "Withdrawl Request", upi_id: params[:upiId], phone: params[:phone], amount: params[:coins], payout_id: params[:payoutId])
            { status: 200, message: MSG_SUCCESS, currency: "USD", showText: "Redeem Request Submitted Successfully", userCoin: user.wallet_balance, userAmount: (user.wallet_balance.to_f / 100).to_s }
          rescue Exception => e
            Rails.logger.info "API Exception-#{Time.now}-transactionList-#{params.inspect}-Error-#{e}"
            { status: 500, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
