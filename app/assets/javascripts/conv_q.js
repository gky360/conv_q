"use strict";

$(function() {

  var d_cq_timer = $("#cq-timer");
  if (d_cq_timer[0] != null) {
    var cq_timer = new CqTimer();
    $("#cq-timer-body").on("click", function() {
      cq_timer.toggle_timer();
    });
  }

  var set_time_zone_offset = function() {
    var current_time = new Date();
    Cookies.set('time_zone', current_time.getTimezoneOffset());
  }
  set_time_zone_offset();

  // clickable tr
  $('tr[data-href] a').click(function(e) {
    e.stopPropagation();
  });
  $('tr[data-href]').addClass('clickable').click(function(e) {
    window.location = $(this).data('href');
  });

});
