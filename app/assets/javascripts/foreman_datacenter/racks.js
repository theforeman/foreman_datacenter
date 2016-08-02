function racksNewSiteSelected(item) {
  var $item = $(item);
  var site = $item.val();
  if (site === '') {
    return false;
  } else {
    foreman.tools.showSpinner();
    var url = $item.data('url');
    var params = $.param({ site_id: site });
    var $container = $('#rack-groups-container');
    $container.load(url + ' #rack-groups', params, function () {
      $container.find('select').select2({allowClear: true});
      foreman.tools.hideSpinner();
    });
  }
}
