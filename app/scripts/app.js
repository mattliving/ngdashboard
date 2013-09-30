'use strict'

angular.module('luckyDashApp', ['luckyDashDirectives', 'luckyDashServices', 'luckyDashFilters', 'ui.bootstrap', 'ngResource', 'ngRoute', 'ngAnimate'])
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when '/',
        templateUrl: '/views/landing.html'
        controller: 'LandingCtrl'
      .when '/404',
        templateUrl: '/views/error.html'
        # controller: 'ErrorCtrl'
      .when '/add/resource',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .otherwise
        redirectTo: '/404'
    $locationProvider.html5Mode true
