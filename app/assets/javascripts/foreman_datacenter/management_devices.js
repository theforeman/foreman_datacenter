$(function () {
  $('[data-reveal-password]').click(function () {
    var $button = $(this);
    var password = $button.data('password');
    var $container = $button.parent();
    $container.empty();
    $container.append('<kbd>' + password + '</kbd>');
  });
});
