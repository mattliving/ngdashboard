'use strict';

var luckyDashApp = angular.module('luckyDashApp', ['luckyDashDirectives', 'luckyDashServices', 'luckyDashFilters', 'ui.bootstrap', 'ngResource', 'ngRoute'])
  .config(function($routeProvider, $locationProvider, $httpProvider) {
    $routeProvider.when('/', {
      redirectTo: '/login'
    }).when('/login', {
      templateUrl: '/views/login.html',
      controller: 'LoginCtrl'
    }).when('/dashboard/:acid', {
      templateUrl: '/views/dashboard.html',
      controller: 'DashboardCtrl'
    }).when('/404', {
      templateUrl: '/views/error.html'
    }).otherwise({
      redirectTo: '/404'
    });
    return $locationProvider.html5Mode(true);
  });


