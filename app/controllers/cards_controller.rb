class CardsController < ApplicationController

  def show
    @card = Card.get_card(current_user.card&.customer_token)
  end
  
  def new
    redirect_to cards_path, notice: "既に登録されています。" if current_user.card
    @card = Card.new
  end

  def create
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]

    customer = Payjp::Customer.create(card: params[:payjp_token]) ## 顧客の作成

    card = current_user.build_card(card_token: params[:card_token], customer_token: customer.id)
    if card.save
      redirect_to cards_path, notice: "カードの登録が完了しました。"
    else
      redirect_to new_card_path, alert: "カードの登録に失敗しました。"
    end
  end

  def destroy
    card = current_user.card

    if card.destroy
      redirect_to cards_path, notice: "カードの削除が完了しました。"
    else
      redirect_to cards_path, notice: "カードの削除に失敗しました。"
    end

  end

end