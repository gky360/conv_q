"use strict";

app.controller("tagsCtrl", ["$scope", "Tag", function($scope, Tag) {
  var ctrl = this;

  $scope.tags_limit = 20;

  ctrl.$onInit = function() {
    console.log("TagsCtrl#onInit");

    $scope.tags = Tag.query();
  };

}]);
