class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :sold_item, only: [:edit, :update, :destroy]
  def index
    @items = Item.order("created_at DESC").limit(3)
  end

  def show
  end

  def new ## 出品ページ
    @item = Item.new
    @item.item_images.build  ## 新規画像用
    render template: 'items/form'
  end

  def create
    redirect_to root_path, notice: "商品の出品に成功しました。" and return if params[:completed]
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: "商品の出品に成功しました。"
    else
      @item.errors.full_messages.each do |m|
        flash.now[:alert] = m
      end
      @item = Item.new(item_params)
      render template: 'items/form'
    end
  end

  def edit
    @item.item_images.build
    render template: 'items/form'
  end

  def update
    redirect_to root_path, notice: "商品の編集に成功しました。" and return if params[:completed]
    if @item.update(item_params)
      redirect_to root_path, notice: "商品の編集に成功しました。"
    else
      @item.errors.full_messages.each do |m|
        flash.now[:alert] = m
      end
      render template: 'items/form'
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: "商品を削除しました。"
  end

  private
  def item_params
    params.require(:item).permit(:name, :price, :detail, :condition, :delivery_fee_payer, :delivery_method, :prefecture_id, :delivery_days, :deal, :category_id, item_images_attributes: [:image, :id, :_destroy]).merge(user_id: current_user.id)
  end

  def set_item
    begin
      @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, notice: "ご指定のアイテムが見つかりません。"
    end
  end

  def sold_item
    redirect_to root_path, alert: "売り切れです" if @item.deal == "sold_out"
  end
end
