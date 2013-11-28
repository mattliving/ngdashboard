
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
    }).when('/404', {
      templateUrl: '/views/error.html'
    }).otherwise({
      redirectTo: '/404'
    });
    return $locationProvider.html5Mode(true);
  });
