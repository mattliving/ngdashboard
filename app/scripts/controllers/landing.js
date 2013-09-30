angular.module("luckyDashApp").controller("LandingCtrl", function($http, $scope, $location) {
  $scope.subscribe = false;
  $scope.location  = $location;
  return $http.get('/api/v1/content/options').success(function(options) {
    return $scope.options = options;
  });
});
