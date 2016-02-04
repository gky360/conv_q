"use strict";

$(function() {
  // 1 秒間に表示を更新する回数
  var FREQ = 4;

  var data = [{
    value: 0,
    color: "#F5F5F5",
    label: ""
  },{
    value: 15,
    color: "#646262",
    label: "Think"
  },{
    value: 45,
    color: "#A1CC3A",
    label: "Speak"
  }];

  var options = {
    //Boolean - Whether we should show a stroke on each segment
    segmentShowStroke : true,
    //String - The colour of each segment stroke
    segmentStrokeColor : "#fff",
    //Number - The width of each segment stroke
    segmentStrokeWidth : 2,
    //Number - The percentage of the chart that we cut out of the middle
    percentageInnerCutout : 50, // This is 0 for Pie charts
    //Number - Amount of animation steps
    animationSteps : 60 / FREQ,
    //String - Animation easing effect
    animationEasing : "linear",
    //Boolean - Whether we animate the rotation of the Doughnut
    animateRotate : false,
    //Boolean - Whether we animate scaling the Doughnut from the centre
    animateScale : false,
  }

  $("#cq-timer-canvas").attr("width", $("#cq-timer").width());
  $("#cq-timer-canvas").attr("height", $("#cq-timer").height());
  var CqTimer = new Chart($("#cq-timer-canvas").get(0).getContext("2d")).Doughnut(data, options);
  CqTimer.seconds = $("#cq-timer-seconds");

  CqTimer.toggle_timer = function() {
    if (CqTimer.timer) {
      CqTimer.stop_timer();
    } else {
      CqTimer.start_timer();
    }
  };

  CqTimer.start_timer = function() {
    console.log("start_timer");
    this.default_for_seconds = this.seconds.clone();
    this.timer = setInterval(this.decrease(this), 1000 / FREQ);
  };

  CqTimer.stop_timer = function() {
    console.log("stop_timer");
    clearInterval(this.timer);
    this.timer = null;
    this.seconds.html(this.default_for_seconds.html());
  };

  CqTimer.reset_timer = function() {
    if (CqTimer.timer) {
      CqTimer.stop_timer();
    }
    for (var i = 0; i < data.length; i++) {
      this.segments[i].value = data[i].value;
    };
    this.update();
  };

  CqTimer.decrease = function(_this) {
    return function() {
      _this.segments[0].value += 1.0 / FREQ;
      if (_this.segments[1].value > 0) {
        _this.seconds.text(Math.ceil(_this.segments[1].value));
        _this.seconds.css("color", data[1].color);
        _this.segments[1].value -= 1.0 / FREQ;
      } else if(_this.segments[2].value > 0) {
        _this.seconds.text(Math.ceil(_this.segments[2].value));
        _this.seconds.css("color", data[2].color);
        _this.segments[2].value -= 1.0 / FREQ;
      } else {
        _this.reset_timer();
      }
      _this.update();
    };
  };

  $("#cq-timer").on("click", function() {
    CqTimer.toggle_timer();
  });

});
