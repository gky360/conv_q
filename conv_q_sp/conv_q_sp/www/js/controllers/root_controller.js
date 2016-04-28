"use strict";

app.controller("RootController", [
    "$scope", "$http", "common", "User",
    function($scope, $http, common, User) {

  console.log(
    "\n\n========================================\n" +
    "[" + new Date() + "]\n\n"
  );

  ons.ready(function() {
    console.log("root#");

    get_token(null, null, function() {
      // always_call
      // ユーザーのログイン状態をチェックする
      app.current_user = new User(function() {});
      $scope.current_user = app.current_user;
    });
  });


  /*
   * @brief サーバーへの GET リクエストを発生させることで、token を取得する
   * @param success_call(response) 成功時のコールバック
   * @param error_call(response)   エラー時のコールバック
   * @param always_call()          常に実行するコールバック
   */
  var get_token = function(success_call, error_call, always_call) {
    console.log("root#get_token");
    $http.get(
      API_ROOT
    ).then(function(response) {
      console.log("GET " + API_ROOT + " success");
      if (success_call) {
        success_call(response);
      }
    }, function(response) {
      console.log("GET " + API_ROOT + " error");
      common.alert_connection_error(function() {
        if (error_call) {
          error_call(response);
        }
      });
    }).finally(function() {
      if (always_call) {
        always_call();
      }
    });
  }

}]);
