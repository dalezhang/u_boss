//= require pnotify/pnotify.custom.min

// 弹框
// js：
// require pnotify
// require pnotify/pnotify.custom.min
// "jquery.pnotify.default",
// css：
//     "jquery.pnotify.default.icons",
//     "pnotify/pnotify.custom.min.css",

function flashNotice(notice,alert,success,info,error) {
  PNotify.prototype.options.styling = "jqueryui";
    var title = "";
    var hide = true;
    var content = "";
    var type = '';
    if (notice != "") {
      title = "注意";
      type = "notice";
      content = notice;
    } else if (alert != "") {
      title = "警告";
      type = "Alert";
      content = alert;
      hide = false;
    } else if (success != "") {
      title = "成功";
      type = "Success";
      content = success;
    } else if (info != "") {
      title = "信息";
      type = "Info";
      content = info;
    } else if (error != "") {
      title = "错误";
      type = "Error";
      content = error;
      hide = false;
    }
//    var headw = $(".head").width();
//    var headl = $(".head").position().left;
//    var headp = headw + headl - 300;
    if (title != "") {
      $(document).ready(function(){
          new PNotify({
              title: title,
              text: content,
              type: type.toLowerCase(),
              hide: hide,
              opacity: .8,
              stack: false
          });
//          $('.alert.ui-pnotify-container').parent().css({
//            top: '10%',
//            left: headp
//          })
      })
    }
}

// 确认框
(function() {
  $.rails.allowAction = function(link) {
    if ($(link).attr('data-confirm')) {
      return $.rails.showConfirmDialog(link);
    } else {
      return true;
    }
  };

  $.rails.confirmed = function(link) {
    link.removeAttr('data-confirm');
    return link.trigger('click.rails');
  };

  $.rails.showConfirmDialog = function(link) {
    var message;
    var modal_overlay;
    message = link.attr('data-confirm');
    (
      new PNotify({
      title: '请确认',
      text: message,
      icon: 'glyphicon glyphicon-question-sign',
      hide: false,
      confirm: {
        confirm: true,
        buttons: [{
            text: '确认',
            addClass: 'btn-primary'
        },{
            text: '取消'
        }]
      },
      buttons: {
        closer: false,
        sticker: false
      },
      history: {
        history: false
      },
        before_open: function(PNotify) {
            // Position this notice in the center of the screen.
            PNotify.get().css({
                "top": ($(window).height() / 2) - (PNotify.get().height() / 2),
                "left": ($(window).width() / 2) - (PNotify.get().width() / 2)
            });
            // Make a modal screen overlay.
            if (modal_overlay) modal_overlay.fadeIn("fast");
            else modal_overlay = $("<div />", {
                "class": "ui-widget-overlay",
                "css": {
                    "display": "none",
                    "position": "fixed",
                    "top": "0",
                    "bottom": "0",
                    "right": "0",
                    "left": "0"
                }
            }).appendTo("body").fadeIn("fast");
        },
        before_close: function() {
            modal_overlay.fadeOut("fast");
        }
    })).get().on('pnotify.confirm', function() {
        $.rails.confirmed(link)
    }).on('pnotify.cancel', function() {
        $(this).fadeOut();
    });
  };
}).call(this);
