function devicesNewManufacturerSelected(item) {
  var $item = $(item);
  var manufacturer = $item.val();
  if (manufacturer === '') {
    return false;
  } else {
    foreman.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ manufacturer_id: manufacturer });
    var $container = $('#device-types-container');
    $container.load(url + ' #device-types', params, function () {
      $container.find('select').select2({allowClear: true});
      foreman.tools.hideSpinner();
    });
  }
}
