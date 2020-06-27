crumb :root do
  link "フリマ", root_path
end

crumb :category_index do
  link "カテゴリー一覧", categories_path
end

crumb :category_show do |category|
  link "#{category.name}", category_path(category)
  parent :category_index
end

crumb :item_show do |item|
  link "#{item.name}", item_path(item)
  parent :category_show, item.category
end

crumb :user_show do |user|
  link "#{user.nickname}さんのマイページ", user_path(user)
end

crumb :card_show do |user|
  link "#{user.nickname}さんのカード一覧", cards_path
  parent :user_show, user
end

crumb :card_new do |user|
  link "#{user.nickname}さんのカード登録", new_cards_path
  parent :card_show, user
end