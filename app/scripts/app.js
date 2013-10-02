'use strict';

var luckyDashApp = angular.module('luckyDashApp', ['luckyDashDirectives', 'luckyDashServices', 'luckyDashFilters', 'ui.bootstrap', 'ngResource', 'ngRoute'])
  .config(function($routeProvider, $locationProvider, $httpProvider) {
    $routeProvider.when('/', {
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

// luckyDashApp.run(function($rootScope, $window) {
//   $rootScope.windowHeight = $window.outerHeight;
//   angular.element($window).bind('resize').function() {
//     $rootScope.windowHeight = $window.outerHeight;
//     $rootScope.$apply('windowHeight');
//   }
// });


