module API
  class Base < Grape::API
    mount API::V1::Auth
    mount API::V1::Appuser
    mount API::V1::Wallet
  end
end
