class CategoriesController < ApplicationController

  def index
  end

  def show
    @category = Category.find(params[:id])
    @items = Item.search_category(@category.subtree_ids).order("created_at DESC")
  end

end
