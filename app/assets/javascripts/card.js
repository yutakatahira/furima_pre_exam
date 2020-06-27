$(function () {
  if (!$('#regist_card')[0]) return false;

  Payjp.setPublicKey("pk_test_2a4dcfeb4e6d07cae67e4780");
  let regist_button = $("#regist_card");

  regist_button.on("click", function (e){
    e.preventDefault();
    const card = {
      number: $("#card_number_form").val(),
      cvc: $("#cvc_form").val(),
      exp_month: $("#exp_month_form").val(),
      exp_year: Number($("#exp_year_form").val()) + 2000
    };
    Payjp.createToken(card, (status, response) => { //cardをpayjpに送信して登録する。
      
      if (status === 200) { //成功した場合
        $("#card_token").append(
          `<input type="hidden" name="payjp_token" value=${response.id}>
          <input type="hidden" name="card_token" value=${response.card.id}>`
        );
        $("#card_number_form").removeAttr("name");
        $("#cvc_form").removeAttr("name");
        $("#exp_month_form").removeAttr("name");
        $("#exp_year_form").removeAttr("name");
        $('#card_form')[0].submit();
      } else { //失敗した場合
        alert("カード情報が正しくありません。");
        regist_button.prop('disabled', false);
      }
    });
  })
});