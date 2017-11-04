$(function () {
  function onSend() {
    tfm.tools.showSpinner();
  }

  function onSuccess() {
    window.location.reload();
  }

  function onComplete() {
    tfm.tools.hideSpinner();
  }

  var selectors = 'a[data-action="connected"], a[data-action="planned"], a[data-action="destroy"]';
  $(selectors).on('ajax:send', onSend)
    .on('ajax:success', onSuccess)
    .on('ajax:complete', onComplete);
});
