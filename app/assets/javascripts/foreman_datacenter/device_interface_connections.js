function connectionsNewRackSelected(item) {
  var $item = $(item);
  var rack = $item.val();
  if (rack === '') {
    return false;
  } else {
    foreman.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ rack_id: rack });
    var $container = $('#devices-container');
    $container.load(url, params, function () {
      $container.find('select').select2({allowClear: true});
      foreman.tools.hideSpinner();
    });
  }
}
