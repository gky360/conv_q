"use strict";

app.controller("UsersController", [
    "$scope", "common", "User",
    function($scope, common, User) {

  /**
   * @brief 初期化処理
   */
  var init = function() {
    console.log("users#init");
    console.log("scope: " + $scope.current_user.email);
    console.log("app: " + app.current_user.email);
  };
  init();

  /**
   * @brief サインイン処理
   */
  $scope.sign_in = function() {
    console.log("users#sign_in");
    app.current_user.sign_in({
      email: $scope.sign_in_form.email,
      password: $scope.sign_in_form.password
    }, function(response) {
      ons.notification.alert({
        title: "ログインが完了しました。",
        messageHTML: "ようこそ " + app.current_user.name + " さん",
        buttonLabel: 'OK',
        callback: after_sign_in_success
      });
    }, function(response) {
      var messageHTML = "";
      if (response === null || response.status === 0) {
        // サーバーに接続できなかったとき
        common.alert_connection_error();
        return;
      } else {
        if (response.errors) {
          messageHTML = common.full_messages_to_html(response.errors); /////////////  
        }
      }
      ons.notification.alert({
        title: "ログインに失敗しました",
        messageHTML: messageHTML,
        buttonLabel: 'OK',
        callback: null
      });
    });

    var after_sign_in_success = function() {
      app.tabbar.setActiveTab(4);
    };
  };

  /**
   * @brief サインアウト処理
   */
  $scope.sign_out = function() {
    console.log("users#sign_out");

    var confirm = function() {
      ons.notification.confirm({
        title: "ログアウト",
        messageHTML: "ログアウトしますか？",
        buttonLabels: ["はい", "いいえ"],
        pimaryButtonIndex: 1,
        cancelable: true,
        callback: after_confirm
      });
    };

    var after_confirm = function(index) {
      if (index !== 0) {
        // 「はい」以外がタップされたとき
        return;
      }

      app.current_user.sign_out(function(response) {
        ons.notification.alert({
          title: "ログアウト完了",
          messageHTML: "ログアウトが完了しました。",
          buttonLabel: 'OK',
          callback: function() {
            app.tabbar.setActiveTab(4);
          }
        });
      }, function(response) {
        var message = "";
        if (response === null || response.status === 0) {
          // サーバーに接続できなかったとき
          common.alert_connection_error();
        } else if ($.inArray(response.errors, "user_not_found") >= 0) {
          ons.notification.alert({
            title: "ログアウトに失敗しました",
            messageHTML: "すでにログアウトしています。",
            buttonLabel: 'OK',
            callback: null
          });
        } else {
          ons.notification.alert({
            title: "ログアウトに失敗しました",
            messageHTML: "時間をあけて再試行してください。",
            buttonLabel: 'OK',
            callback: null
          });
        }
      });
    };

    confirm();
  };

}]);
