"use strict";

app.controller("tagsCtrl", ["$scope", "Tag", function($scope, Tag) {
  var ctrl = this;

  $scope.tags_limit = 20;

  ctrl.$onInit = function() {
    console.log("TagsCtrl#onInit");

    $scope.tags = Tag.query(
      {},
      ctrl.set_tags
    );
  };

  ctrl.set_tags = function() {
    console.log("TagsCtrl#set_tags");

    var source_tags = $scope.tags.map(function(tag) {
      return tag.name
    });
    $("#tag_names").tagit({
      autocomplete: {
        delay: 0,
        source: source_tags
      }
    });
  };
}]);
