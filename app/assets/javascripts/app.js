var app = angular.module('convQApp', []);

// CSRFのトークンを設定するようにする
app.config(['$httpProvider', function($httpProvider) {
  var authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
}]);

// AngularJSがturbolinksと一緒に動くようにする
$(document).on('page:load', function() {
  $('[ng-app]').each(function() {
    var module = $(this).attr('ng-app');
    angular.bootstrap(this, [module]);
  });
});
