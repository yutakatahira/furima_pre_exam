require "csv"
#csvファイルを扱うためのgemを読み込む

CSV.foreach('db/categories_view.csv') do |row|
#foreachは、ファイル（hoge.csv）の各行を引数として、ブロック(do~endまでを範囲とする『引数のかたまり』)を繰り返し実行する
#rowには、読み込まれた行が代入される

Category.create(:name => row[1], :ancestry => row[2])
#usersテーブルの各カラムに、各行のn番目の値を代入している。

end