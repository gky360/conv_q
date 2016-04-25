"use strict";

app.controller("TopicsController", [
    "$scope", "common", "Topic",
    function($scope, common, Topic) {

  /**
   * @brief 初期化処理
   */
  var init = function() {
    console.log("topics#init");
  };
  init();

  $scope.index = function() {
    Topic.query(
      {},
      function(topics, responseHeaders) {
        $scope.topics = topics;
      },
      function(httpResponse) {

      }
    );
  };

  $scope.rand_for_user = function() {
    Topic.rand_for_user(
      { limit: 1 },
      function(topics, responseHeaders) {
        $scope.topic = topics[0];
      },
      function(httpResponse) {

      }
    );
  };

}]);
