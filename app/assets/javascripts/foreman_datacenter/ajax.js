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
