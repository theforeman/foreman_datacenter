$(function () {
  var modal = $('#myModal');
  var btn = $('#init-modal');
  var span = $('.close');
  btn.click(function() {
    modal.css("display","block");
  });
  span.click(function() {
    modal.css("display","none");
  });
  $(window).click(function(event) {
    if (event.target.id == "myModal") {
      modal.css("display","none");
    }
  });
  $(document).keyup(function(e) {
    if (e.keyCode === 27) {
      modal.css("display","none");
    }
  });
});
