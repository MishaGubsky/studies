function add() {
    $('.js-add').append( `<p>${$('.input').val()}</p>` );
}

$.ajax({
  type: "POST",
  url: "/Controller/Method",
  success: function(msg){
    alert( "Прибыли данные: " + msg );
  },
  error : function() {
  	alert("Ошибка при отправке!");
  }
});