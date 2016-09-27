"use strict";

var ENV = "localbrowser";

// API のルート URL 設定
if (ENV === "development") {
  var API_ROOT = "http://192.168.1.3:3000/api/v1";
  // var API_ROOT = "http://172.20.10.4:3000/api/v1";
} else if (ENV === "localbrowser") {
  var API_ROOT = "http://localhost:3000/api/v1";
} else if (ENV === "production") {
  var API_ROOT = "https://conv-q.herokuapp.com/api/v1";
}

// localbrowser 環境で monaca console の挙動を上書き
if (ENV === "localbrowser") {
  monaca.console.sendLog = function(level, url, line, char, args) {
    if (args.length === 1) {
      _console[level](args[0]);
    } else {
      _console[level](args);
    }
  }
}

var app = angular.module("convQApp", [
  "onsen",
  "ngCookies",
  "ngResource",
  "ng-token-auth"
]);

// API アクセスの設定
app.config(function($httpProvider) {
  $httpProvider.defaults.headers.common['Content-Type'] = 'application/json; charset=utf-8';

  $httpProvider.interceptors.push(function($cookies) {
    /**
     * @brief レスポンスヘッダの Set-Cookie の項に基づき、cookie をセットする
     * @param response レスポンスオブジェクト
     */
    var set_cookies = function(response) {
      var set_cookie_str = response.headers("Set-Cookie");
      if (!set_cookie_str) {
        return;
      }
      // console.log(set_cookie_str);
      set_cookie_str.split(",").forEach(function(cookie) {
        if (!cookie) {
          return;
        }
        var cookie_key, cookie_val;
        var options = new Array();
        cookie.split(";").forEach(function(str, idx) {
          var eq_idx = str.indexOf("=");
          if (eq_idx != -1) {
            var key = str.substring(0, eq_idx).trim();
            var val = unescape(str.substring(eq_idx + 1, str.length).trim());
            if (idx == 0) {
              cookie_key = key;
              cookie_val = val;
            } else {
              options[key] = val;
            }
          }
        });
        $cookies.put(cookie_key, cookie_val, options);
      });
    };

    return {
      /**
       * @brief GET を除くリクエストのヘッダに毎回 CSRF トークンをつける
       */
      request: function(config) {
        if ($.inArray(config.method, ["POST", "PUT", "PATCH", "DELETE"]) >= 0) {
          config.headers["X-XSRF-TOKEN"] = $cookies.get("XSRF-TOKEN");
        };
        config.timeout = 10000;
        return config;
      },
      response: function(response) {
        set_cookies(response);
        // console.log("document.cookie: " + document.cookie);
        return response;
      }
    };
  });
});

// ng-token-auth の設定
app.config(function($authProvider) {
  $authProvider.configure({
    apiUrl: API_ROOT,
    handleLoginResponse: function(response) {
      return response;
    },
    handleAccountUpdateResponse: function(response) {
      return response;
    },
    handleTokenValidationResponse: function(response) {
      return response;
    }
  });
});
