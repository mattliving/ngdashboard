'use strict'

# I know you're not meant to do this, but not having an array removal function
# is incredibly annoying. Nice one JavaScript.
# Array::remove = (e) -> @splice i, 1 if (i = @indexOf e) isnt -1

# John Resig's remove implementation MIT licensed
Array::remove = (from, to) ->
  rest = @slice((to or from) + 1 or @length)
  @length = (if from < 0 then @length + from else from)
  @push.apply this, rest

angular.module('jobFoundryApp', ['jobFoundryDirectives', 'jobFoundryServices', 'jobFoundryFilters', 'resourceData', 'ui.bootstrap', 'ngResource', 'ngRoute', 'ngAnimate'])
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: '/views/landing.html'
        controller: 'LandingCtrl'
      .when '/getting-started',
        templateUrl: 'views/getting-started.html'
        controller: 'DecisionFlowCtrl'
      .when '/add',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .when '/edit/:id',
        templateUrl: '/views/resource-form.html'
        controller: 'ResourceCtrl'
      .when '/list/:path',
        templateUrl: '/views/list.html'
        controller: 'ResourceCtrl'
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
    return
