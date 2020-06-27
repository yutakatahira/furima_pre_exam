class Api::ItemsController < ApplicationController

  def create
    @item = Item.new(item_params)
    @item.save
    @error = @item.errors.full_messages if @item.errors.full_messages.present?
  end

  def update
    @item = current_user.items.find(params[:id])
    @item.update(item_params)
    @error = @item.errors.full_messages if @item.errors.full_messages.present?
  end

  private
  def item_params
    params.require(:item).permit(:name, :price, :detail, :condition, :delivery_fee_payer, :delivery_method, :prefecture_id, :delivery_days, :deal, :category_id, item_images_attributes: [:image, :id, :_destroy]).merge(user_id: current_user.id)
  end

end
