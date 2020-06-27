// カテゴリの大枠のフォームを組み立てる関数
function buildCategoryForm(categories) {
  let options = '';
  // カテゴリを一つずつ渡してoptionタグを一つずつ組み立てていく。
  categories.forEach(function (category) {
    options += buildOption(category);
  });

  let blank = "---";
  let html = `
              <select required="required" name="item[category_id]" class="select-category">
              <option value="">${blank}</option>
                ${options}
              </select>
              `
    return html;
}

// 渡されたデータを使ってoptionタグを組み立てる関数
function buildOption(category) {
  let option = `
                <option value="${category.id}">${category.name}</option>
               `
  return option;
}


$(document).on("change", ".select-category", function () {
  var category_id = $(this).val();
  if (!category_id) { // "---"を選択したとき i.e."category_id = null"のとき
    $(this).nextAll('.select-category').remove();
    return false;
  }
  $.ajax({
      url: `/api/categories`,
      type: 'GET',
      data: {
        category_id: category_id
      },
      dataType: 'json',
  })
  .done(function (categories) {
    // categoriesがない => 
    if (categories.choices.length == 0){
      return false;
    }

    var html = buildCategoryForm(categories.choices)
    $(this).nextAll('.select-category').remove();
    $("select.select-category:last").after(html);
  }.bind(this));
});