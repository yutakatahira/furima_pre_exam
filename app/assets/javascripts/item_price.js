$(function(){
  if (!$('#selected-item-images')[0]) return false;
  const min_price = 300;

  function changeFeeAndProfit() {
    $("#fee").text("-");
    $("#profit").text("-");
    if ($("#item_price").val().match(/\./)) return false;
    if (isNaN($("#item_price").val())) return false;
    let price = Number($("#item_price").val());
    if (Number(price) < min_price) return false;
    let fee = Math.floor(price * 0.1);
    let Fee = fee.toLocaleString();
    let Price = (price - fee).toLocaleString();
    
    $("#fee").text(`¥${Fee}`);
    $("#profit").text(`¥${Price}`);
  }

  changeFeeAndProfit();

  $("#item_price").on("input", function () {
    changeFeeAndProfit();
  })
});