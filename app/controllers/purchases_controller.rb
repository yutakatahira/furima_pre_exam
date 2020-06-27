class PurchasesController < ApplicationController
  before_action :set_item
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :user_is_seller
  before_action :sold_item
  

  def new
    @card = Card.get_card(current_user.card&.customer_token)
    @address = Address.find(current_user.id)
  end

  def create
    redirect_to cards_path, alert: "クレジットカードを登録してください" and return unless current_user.card.present?
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]
    customer_token = current_user.card.customer_token
    Payjp::Charge.create(
      amount: @item.price, # 商品の値段
      customer: customer_token, # 顧客、もしくはカードのトークン
      currency: 'jpy'  # 通貨の種類
    )
    ## -----追加ここから-----
    @item.update(deal: 1)
    @item.update(buyer_id: current_user.id)
    ## -----追加ここまで-----
    redirect_to item_path(@item), notice: "商品を購入しました"
  end

  private
  def user_is_seller
    redirect_to root_path, alert: "自分で出品した商品は購入できません" if @item.user_id == current_user.id
  end

  def set_item
    begin
      @item = Item.find(params[:item_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "ご指定のアイテムが見つかりません。"  
    end
  end

  def sold_item
    redirect_to root_path, alert: "売り切れです" if @item.deal == "sold_out"
  end
  
end
