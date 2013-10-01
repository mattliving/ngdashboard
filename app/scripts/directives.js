
angular.module('luckyDashDirectives', ['luckyDashServices']);

angular.module('luckyDashDirectives').directive('metricTile', function() {
  return {
    restrict: 'E',
    scope: {
      title: '@',
      metric: '@',
      width: '@'
    },
    templateUrl: "/views/metric-tile.html",
    link: function(scope, elem, attrs) {

    }
  };
});

angular.module('luckyDashDirectives').directive('graphTile', function() {
  return {
    restrict: 'E',
    scope: {
      title: '@',
      metric: '@'
    },
    templateUrl: "/views/graph-tile.html",
    link: function(scope, elem, attrs) {

    }
  };
});

angular.module('luckyDashDirectives').directive('resize', function($window) {
  return function (scope) {
    scope.width  = $window.innerWidth;
    scope.height = $window.innerHeight;
    angular.element($window).bind('resize', function() {
      scope.$apply(function() {
        scope.width  = $window.innerWidth;
        scope.height = $window.innerHeight;
      });
    });
  };
});
