"use strict";

app.factory("Tag", ["$resource", function($resource){
  var Tag = $resource(API_ROOT + "/tags");

  return Tag;
}]);
