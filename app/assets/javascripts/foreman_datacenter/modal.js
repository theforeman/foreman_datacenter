$(window).click(function(event) {
  if (event.target.id == "init-modal") {
    var data = $(event.target).data();
    var object_type = data.objecttype
    var object_name = data.objectname
    var object_id = data.objectid
    var ao = data.associatedobjects
    var pathname = window.location.pathname; // Returns path only
    var str = "/" + object_id;
    var patt = new RegExp(str);
    console.log(object_type);
    if (object_type == 'device') {
      var checkbox_label = 'Delete associated host ONLY and keep current device as UNASSIGNED!'
    } else {
      var checkbox_label = 'Delete ' +  object_type + ' ONLY'
    }

    if (!(patt.test(pathname))) {
      pathname = pathname + str
    }

    var form = '<div id="myModal" class="modal"> \
      <div class="modal-content"> \
        <div class="modal-header"> \
          <span class="close">&times;</span> \
          <h4>Are you absolutely sure?</h4> \
        </div> \
        <div class="modal-header2"> \
          <h4>Unexpected bad things will happen if you don’t read this!</h4> \
        </div> \
        <div class="modal-body"> \
          <p>This action \
            <strong>cannot</strong> \
            be undone. By unselecting checkbox you will permanently delete the \
            <strong>' + object_name + '</strong> \
            with \
            <strong>all</strong> \
            associated objects' + ao + ' \
          </p> \
          <form class="modal-form nonpaddingbottom" action=' + pathname + ' accept-charset="UTF-8" method="post"> \
            <input type="hidden" name="_method" value="delete"> \
            <input type="checkbox" name="object_only" id="object_only" value="true" checked="checked"> \
            <label>' + checkbox_label + '</label> \
            <input type="submit" name="commit" value="I understand the consequences, delete this ' + object_type + '" class="btn btn-block btn-danger modal-btn modal-btn-danger"> \
	  </form> \
          <p>You also can move associated object to another <strong>' + object_type + '</strong> before you destroy it.</p> \
          <a class="btn btn-block btn-primary modal-btn modal-btn-primary marginbottomsixteen" href="/datacenter/' + object_type + 's/' + object_id + '/move">Move associated objects</a> \
        </div> \
      </div> \
    </div>'

    $('#main').append(form).html_safe
    var modal = $('#myModal');
    var btn = $('#init-modal');
    var span = $('.close');
    modal.css("display","block");

    span.click(function() {
      modal.css("display","none");
      $('.modal').remove();
    });

    $(document).keyup(function(e) {
      if (e.keyCode === 27) {
        $('.modal').remove();
      }
    });

    $(window).click(function(event) {
      if (event.target.id == "myModal") {
        $('.modal').remove();
      }
    });
  }
});
