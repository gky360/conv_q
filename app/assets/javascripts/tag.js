"use strict";

app.factory("Tag", ["$resource", function($resource){
  var strip_tags_data = function(data) {
    data = angular.fromJson(data)
    console.log(data);
    return data.tags;
  }

  var Tag = $resource(API_ROOT + "/tags", {}, {
    query: {
      isArray: true,
      transformResponse: strip_tags_data
    }
  });

  return Tag;
}]);
