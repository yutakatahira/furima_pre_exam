class Card < ApplicationRecord
  belongs_to :user, optional: true

  validates :customer_token, presence: true

  private
  def self.get_card(customer_token)  ## カード情報を取得する。支払い方法ページで使用する。
    return nil unless customer_token
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    customer = Payjp::Customer.retrieve(customer_token)
    card = {}
    card_data = customer.cards.retrieve(customer.default_card)
    card[:last4] = "************" + card_data.last4
    card[:exp_month]= card_data.exp_month
    card[:exp_year] = card_data.exp_year - 2000
    card[:brand] = card_data.brand
    return card
  end
end
