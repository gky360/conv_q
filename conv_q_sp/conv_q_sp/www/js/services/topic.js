"use strict";

app.factory("Topic", ["$resource", function($resource) {
  /*
   * @brief wrap されたデータから topics 本体を取り出す
   */
  var unwrap_topics_data = function(data) {
    data = angular.fromJson(data)
    console.log(data);
    return data.topics;
  }

  /*
   * @brief wrap されたデータから topic 本体を取り出す
   */
  var unwrap_topic_data = function(data) {
    data = angular.fromJson(data)
    console.log(data);
    return data.topic;
  }

  var Topic = $resource(API_ROOT + "/topics", {}, {
    query: {
      isArray: true,
      transformResponse: unwrap_topics_data
    },
    rand_for_user: {
      method: "GET",
      url: API_ROOT + "/topics/rand_for_user",
      isArray: true,
      transformResponse: unwrap_topics_data
    }
  });

  return Topic;
}]);
