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

function connectionsNewDeviceSelected(item) {
  var $item = $(item);
  var device = $item.val();
  if (device === '') {
    return false;
  } else {
    foreman.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ device_id: device });
    var $container = $('#interfaces-container');
    $container.load(url + ' #interfaces-list', params, function () {
      $container.find('select').select2({allowClear: true});
      foreman.tools.hideSpinner();
    });
  }
}
