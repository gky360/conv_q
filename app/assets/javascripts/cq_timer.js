"use strict";

var CqTimer = function() {
  // 1 秒間に表示を更新する回数
  this.FREQ = 4;

  this.data = [{
    value: 0,
    color: "#F5F5F5",
    label: ""
  },{
    value: 1,
    // REMOVE
    // value: 15,
    color: "#646262",
    label: "Think"
  },{
    value: 1,
    // REMOVE
    // value: 45,
    color: "#A1CC3A",
    label: "Speak"
  }];

  this.options = {
    //Boolean - Whether we should show a stroke on each segment
    segmentShowStroke : true,
    //String - The colour of each segment stroke
    segmentStrokeColor : "#fff",
    //Number - The width of each segment stroke
    segmentStrokeWidth : 2,
    //Number - The percentage of the chart that we cut out of the middle
    percentageInnerCutout : 50, // This is 0 for Pie charts
    //Number - Amount of animation steps
    animationSteps : 60 / this.FREQ,
    //String - Animation easing effect
    animationEasing : "linear",
    //Boolean - Whether we animate the rotation of the Doughnut
    animateRotate : false,
    //Boolean - Whether we animate scaling the Doughnut from the centre
    animateScale : false,
  }

  var done_submit = $("#cq-timer-done-submit");
  if (done_submit[0] != null) {
    done_submit.prop("disabled", true);
  }
  this.seconds = $("#cq-timer-seconds");
  this.chart = new Chart($("#cq-timer-canvas").get(0).getContext("2d")).Doughnut(this.data, this.options);
};

CqTimer.prototype.toggle_timer = function() {
  if (this.timer) {
    this.stop_timer();
  } else {
    this.start_timer();
  }
};

CqTimer.prototype.start_timer = function() {
  console.log("start_timer");
  this.default_for_seconds = this.seconds.clone();
  this.timer = setInterval(this.decrease(this), 1000 / this.FREQ);
};

CqTimer.prototype.stop_timer = function() {
  console.log("stop_timer");
  clearInterval(this.timer);
  this.timer = null;
  this.seconds.html(this.default_for_seconds.html());
};

CqTimer.prototype.reset_timer = function() {
  if (this.timer) {
    this.stop_timer();
  }
  for (var i = 0; i < this.data.length; i++) {
    this.chart.segments[i].value = this.data[i].value;
  };
  this.chart.update();
};

CqTimer.prototype.decrease = function(_this) {
  return function() {
    _this.chart.segments[0].value += 1.0 / _this.FREQ;
    if (_this.chart.segments[1].value > 0) {
      _this.seconds.text(Math.ceil(_this.chart.segments[1].value));
      _this.seconds.css("color", _this.data[1].color);
      _this.chart.segments[1].value -= 1.0 / _this.FREQ;
    } else if(_this.chart.segments[2].value > 0) {
      _this.seconds.text(Math.ceil(_this.chart.segments[2].value));
      _this.seconds.css("color", _this.data[2].color);
      _this.chart.segments[2].value -= 1.0 / _this.FREQ;
    } else {
      _this.reset_timer();
      var done_submit = $("#cq-timer-done-submit");
      if (done_submit[0] != null) {
        done_submit.prop("disabled", false);
      }
    }
    _this.chart.update();
  };
};
