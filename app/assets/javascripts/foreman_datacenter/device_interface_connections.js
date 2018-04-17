function connectionsNewRackSelected(item) {
  var $item = $(item);
  var rack = $item.val();
  if (rack === '') {
    return false;
  } else {
    tfm.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ rack_id: rack });
    var $container = $('#devices-container');
    $container.load(url, params, function () {
      $container.find('select').select2({allowClear: true});
      tfm.tools.hideSpinner();
    });
  }
}

function connectionsNewSiteSelected(item) {
  var $item = $(item);
  var site = $item.val();
  if (site === '') {
    return false;
  } else {
    tfm.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ site_id: site });
    var $container = $('#dic-container');
    $container.load(url, params, function () {
      $container.find('select').select2({allowClear: true});
      tfm.tools.hideSpinner();
    });
  }
}
