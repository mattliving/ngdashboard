angular.module("jobFoundryApp").controller "LandingCtrl", ($http, $scope, $location) ->

  $scope.subscribe = false
  $scope.location = $location

  $http.get('/api/v1/content/options').success (options) ->
    $scope.options = options
