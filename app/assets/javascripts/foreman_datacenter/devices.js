function devicesNewManufacturerSelected(item) {
  var $item = $(item);
  var manufacturer = $item.val();
  if (manufacturer === '') {
    return false;
  } else {
    tfm.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ manufacturer_id: manufacturer });
    var $container = $('#device-types-container');
    $container.load(url + ' #device-types', params, function () {
      $container.find('select').select2({allowClear: true});
      tfm.tools.hideSpinner();
    });
  }
}

function devicesNewSiteSelected(item) {
  var $item = $(item);
  var site = $item.val();
  if (site === '') {
    return false;
  } else {
    tfm.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ site_id: site });
    var $container = $('#sites-container');
    $container.load(url + ' #sites', params, function () {
      $container.find('select').select2({allowClear: true});
      tfm.tools.hideSpinner();
    });
  }
}
