$(document).on("ready page:load", function() {

  var d_cq_timer = $("#cq-timer");
  if (d_cq_timer[0] != null) {
    var cq_timer = new CqTimer();
    $("#cq-timer-body").on("click", function() {
      cq_timer.toggle_timer();
    });
  }

});
