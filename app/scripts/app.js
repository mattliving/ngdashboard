
'use strict';

var luckyDashApp = angular.module('luckyDashApp', ['luckyDashDirectives', 'luckyDashServices', 'luckyDashMetrics', 'luckyDashGraphs', 'luckyDashFilters', 'ui.bootstrap', 'ngResource', 'ngRoute', 'ngTouch'])
  .config(function($routeProvider, $locationProvider, $httpProvider) {
    $routeProvider.when('/', {
      redirectTo: '/login'
    }).when('/login', {
      templateUrl: '/views/login.html',
      controller: 'LoginCtrl'
    }).when('/:email/dashboard', {
      templateUrl: '/views/dashboard.html',
      controller: 'DashboardCtrl'
    }).when('/:email/dashboard/verify', {
      controller: function($routeParams, $http) {
        console.log("in verify");
        $http.get($routeParams.email + 'dashboard/verify');
      }
    }).when('/401', {
      templateUrl: '/views/error.html'
    }).when('/404', {
      templateUrl: '/views/error.html'
    }).otherwise({
      redirectTo: '/404'
    });
    return $locationProvider.html5Mode(true);
  });
