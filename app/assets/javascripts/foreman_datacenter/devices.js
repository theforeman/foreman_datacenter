$(function () {
  function onSend() {
    foreman.tools.showSpinner();
  }

  function onSuccess() {
    window.location.reload();
  }

  function onComplete() {
    foreman.tools.hideSpinner();
  }

  var selectors = 'a[data-action="connected"], a[data-action="planned"], a[data-action="destroy"]';
  $(selectors).on('ajax:send', onSend)
    .on('ajax:success', onSuccess)
    .on('ajax:complete', onComplete);
});

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

function devicesNewSiteSelected(item) {
  var $item = $(item);
  var site = $item.val();
  if (site === '') {
    return false;
  } else {
    foreman.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ site_id: site });
    var $container = $('#sites-container');
    $container.load(url + ' #sites', params, function () {
      $container.find('select').select2({allowClear: true});
      foreman.tools.hideSpinner();
    });
  }
}
