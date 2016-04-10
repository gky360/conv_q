"use strict";

app.factory("common", function() {
  return {
    /**
     * @brief サーバーに接続できなかった旨のダイアログを表示する
     * @param after_ok OKボタンが押された後のコールバック
     */
    alert_connection_error: function(after_ok) {
      ons.notification.alert({
        title: "サーバーに接続できませんでした。",
        messageHTML: "インターネットへの接続を確認して再試行してください。",
        buttonLabel: 'OK',
        callback: after_ok
      });
    },

    /**
     * @brief rails のバリデーションエラーのメッセージを html に整形する
     * @param {array} full_messages エラーメッセージの配列
     * @return {string} html 文字列
     */
    full_messages_to_html: function(full_messages) {
      full_messages = (full_messages === undefined) ? {} : full_messages;
      var message_html = "<ul>";
      full_messages.forEach(function(full_message) {
        message_html += "<li>" + full_message + "</li>";
      });
      message_html += "</ul>";
      return message_html;
    }
  };
});
