"use strict";

app.factory("User", function($auth) {
  // ユーザーのログイン状態 (private)
  var is_signed_in = false;

  /**
   * @brief コンストラクタ
   * @detail token が有効かどうかをサーバーに問い合わせ、有効であれば各プロパティを設定、
   *         無効であれば各プロパティは null または false になる。
   * @param callback() token が有効かを問い合わせた後に実行するコールバック
   */
  var User = function(callback) {
    console.log('User#');
    $auth.validateUser().then((function(_this) {
      return function(response) {
        console.log(response);
        _this.set_attr(response.data);
        is_signed_in = response.signedIn ? true : false;
      };
    })(this), (function(_this) {
      return function(reason) {
        console.log(reason);
        _this.set_attr({});
      };
    })(this)).finally(function() {
      if (callback) {
        callback();
      }
    });
  };

  /**
   * @brief ログイン処理を行い、成功したら各プロパティを設定する
   * @param {object} params        ユーザーの email, password を key に持つ object
   * @param success_call(response) 成功時のコールバック
   * @param error_call(response)   エラー時のコールバック
   * @param always_call()          常に実行するコールバック
   */
  User.prototype.sign_in = function(params, success_call, error_call, always_call) {
    console.log("User#sign_in");
    $auth.submitLogin({
      email: params.email,
      password: params.password
    }).then((function(_this) {
      return function(response) {
        console.log("sign_in success");
        console.log(response);
        _this.set_attr(response.data);
        is_signed_in = response.signedIn ? true : false;
        if (success_call) {
          success_call(response);
        }
      };
    })(this), (function(_this) {
      return function(reason) {
        console.log("sign_in fail");
        console.log(reason);
        if (error_call) {
          error_call(reason.resp);
        }
      };
    })(this)).finally(function(){
      if (always_call) {
        always_call();
      }
    });
  };

  /**
   * @brief ログアウト処理を行い、成功したら各プロパティをリセットする
   * @param success_call(response) 成功時のコールバック
   * @param error_call(response)   エラー時のコールバック
   * @param always_call()          常に実行するコールバック
   */
  User.prototype.sign_out = function(success_call, error_call, always_call) {
    console.log("User#sign_out");
    $auth.signOut().then((function(_this) {
      return function(response) {
        console.log(response);
        _this.set_attr({});
        is_signed_in = false;
        if (success_call) {
          success_call(response);
        }
      };
    })(this), (function(_this) {
      return function(response) {
        console.log(response);
        if (error_call) {
          error_call(response);
        }
      };
    })(this)).finally(function() {
      if (always_call) {
        always_call();
      }
    });
  };

  /**
   * @return {bool} ユーザーがログインしているかどうか
   */
  User.prototype.is_signed_in = function() {
    return is_signed_in;
  };

  /**
   * @brief 各プロパティを設定する
   * @param {object} attr 設定したいプロパティの連想配列
   */
  User.prototype.set_attr = function(attr) {
    console.log('User#set_attr');
    this.id = attr.id;
    this.name = attr.name;
    this.account = attr.account;
    this.status = attr.status;
    this.email = attr.email;
  };

  return User;
});
