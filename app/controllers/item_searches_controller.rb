class ItemSearchesController < ApplicationController
  def index
    if params[:q]
      key = params[:q][:category_id_in]
      ## params[:q]の中身があるときの処理
      ########商品名検索########
      params[:q][:name_cont_any] = params[:name_search].squish.split(" ")  ## 入力内容を半角スペースで区切って配列を作成する

      ########カテゴリ関連処理########
      ## ↓ params[:q][:category_id_in]がない時は定義しておく
      key = [] unless key
      ## ↓ @grandchild_category_idsは孫カテゴリたちのチェック状態用
      @grandchild_category_ids = key
      ## ↓親カテゴリが何かしら選択されたなら@parent_categoryを定義する
      @parent_category = Category.find(key[0]) if key[0].present?
      ## ↓子カテゴリが何かしら選択されたなら@parent_categoryを定義する
      @child_category = Category.find(key[1]) if key[1].present?
      ## ↓親カテゴリが選択されていて子カテゴリが「全て」の時、親カテゴリに属しているカテゴリ全てを検索対象とする
      ## 例えば親カテゴリが「レディース」で子カテゴリが「すべて」なら「レディース」に属しているカテゴリ全てをqに入れる
      key = @parent_category.subtree_ids if key[1] == ""
      ## ↓子カテゴリが選択されていて孫カテゴリが選択されていない時、子カテゴリに属しているカテゴリ全てを対象とする
      if key[1].present? && key[2].blank?
        key = (key + @child_category.subtree_ids).uniq
      end
    else
      ## params[:q]の中身がないときの処理
      params[:q] = { sorts: 'id DESC' } ## 検索フォーム外から直接アクセスした時は新しい順にしておく
    end
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true).includes(:item_images).page(params[:page]).per(6)

    @order = [["価格が安い順", "price ASC"], ["価格が高い順", "price DESC"], ["出品が新しい順", "created_at DESC"], ["出品が古い順", "created_at ASC"]]
    @price_list = [["300~1000", "300,1000"], ["1000~5000", "1000,5000"], ["5000~10000", "5000,10000"], ["10000~30000", "10000,30000"]]
  end
end
