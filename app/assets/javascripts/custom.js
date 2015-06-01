// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= require jquery
//= require jquery.validate



// 中间功能
$(function(){
  $("div.head div.center_menu").hover(function(){
    $(this).find(".show_menu").show();
  },function(){
    $(this).find(".show_menu").hide();
  })

  $(".work_action a").hover(function(){
    $(this).find("div:first").hide();
    $(this).find("div:last").show();
  },function(){
    $(this).find("div:first").show();
    $(this).find("div:last").hide();
  })
  function tabs(tabTit,on,tabCon){
    $(tabCon).each(function(){
      $(this).children().eq(0).show();
    });
    $(tabTit).each(function(){
      $(this).children().eq(0).addClass(on);
    });
    $(tabTit).children().hover(function(){
      $(this).addClass(on).siblings().removeClass(on);
      var index = $(tabTit).children().index(this);
      $(tabCon).children().eq(index).show().siblings().hide();
    });
  }
  tabs(".tab-hd","active",".tab-bd");

});
// 中间功能
$(document).ready(function() {
  var dt = new Date();
  var currentDate = new Date();
  var day = currentDate.getDate();
  var month = currentDate.getMonth() + 1;
  var year = currentDate.getFullYear();
  var now = year + "-" + month + "-" + day;

  $(".time_datepicker").one("click", function() {
    $(this).val(now);
  })

  // $('body').on('ajax:before','[data-remote]', function() {
  //   var $loader = $('#remote-loader');
  //   if (!$loader.length) {
  //     $loader = $('<div id="remote-loader"></div>').hide().prependTo($('body'));
  //   }
  //   $loader.html('<span class="label label-warning">正在加载...</span>');
  //   $loader.fadeIn();
  // }).ajaxSuccess(function() {
  //   var $loader = $('#remote-loader');
  //   $loader.html('<span class="label label-warning">操作成功</span>');
  //   setTimeout(function() {
  //     $loader.fadeOut(function(){
  //       $(this).remove();
  //     });
  //   }, 500);
  // }).ajaxError(function(event, xhr, status) {
  //   var $loader = $('#remote-loader');
  //   var error_message = "<span class='label label-important'>" + xhr.responseText + "</span>";
  //   var $error = $($(error_message));
  //   $loader.html($error);
  //   $error.click(function() {
  //     $loader.fadeOut(function(){
  //       $(this).remove();
  //     });
  //   });
  // })

  $("body").on('click',"#check_all", function(){
    $(".check").attr("checked",this.checked);
  })

  $('body').on('click',".hidden-wrap", function(event) {
    event.preventDefault();
    $(this).parent().hide();
  })

  $("body").delegate('div.topic', 'mouseover', function() {
    $(this).addClass('is-topic-mouseover');
  })

  $("body").delegate('div.topic', 'mouseout', function() {
    $(this).removeClass('is-topic-mouseover');
  })

  $("body").delegate('div.topic', 'click', function() {
    var check = $(this).find(".check");
    check.trigger('click');
  })

  $("body").delegate('.check', 'click', function(event) {
    event.stopPropagation();
    $(".select_all_wrap").show();
  })

  $("body").delegate('.topic a', 'click', function(event) {
    event.stopPropagation();
    var link = $(this);
    if( link.data('confirm') ) {
      if($.rails.allowAction(link)) {
        $.rails.handleMethod($(this));
        return false;
      } else {
        return false;
      }
    }
  })

  $("body").delegate(".list tr", 'click', function() {
    var check = $(this).find(".check");
    check.trigger('click');
  })

  $("body").delegate('.list tr a', 'click', function(event) {
    event.stopPropagation();
  })

  $('.search_form form').submit(function() {
    var valuesToSubmit = $(this).serialize();
    if ( $(".topics").length > 0 ) {
      var record_wrap = ".topics"
    } else {
      var record_wrap = ".work_list"
    }
    $.ajax({
      url: $(this).attr('action'),
      data: valuesToSubmit,
      beforeSend: function() {
        $('<img class="loading_img loadding_pt" src="/t/colorful/gif_preloader.gif" alt="" />').appendTo(record_wrap);
      },
      success: function() {
        $(record_wrap).find("img.loadding_pt").hide();
      }
    })
    return false;
  })
})

$( document ).ajaxStart(function() {
$( "#loading" ).show();
});
$( document ).ajaxSuccess(function() {
$( "#loading" ).fadeOut();
});