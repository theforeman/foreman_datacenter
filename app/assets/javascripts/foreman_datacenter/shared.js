function newDeviceSelected(item) {
  var $item = $(item);
  var $mainContainer = $item.closest('#devices-container');
  var id = $item.val();
  if (id === '') {
    return false;
  } else {
    var url = $mainContainer.data('url');
    var fragment = $mainContainer.data('fragment');
    if (fragment) url += ' ' + fragment;
    var params = $.param({device_id: id});
    var $targetContainer = $($mainContainer.data('target'));
    tfm.tools.showSpinner();
    $targetContainer.load(url, params, function () {
      $targetContainer.find('select').select2({allowClear: true});
      tfm.tools.hideSpinner();
    });
  }
}
