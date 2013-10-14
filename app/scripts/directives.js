
angular.module('luckyDashDirectives', ['luckyDashServices']);

angular.module('luckyDashDirectives').directive('metricTile', function() {
  return {
    restrict: 'E',
    scope: {
      title: '@',
      value: '=',
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
      data: '=',
      height: '=',
      width: '='
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

angular.module('luckyDashDirectives').directive('barChart', function() {

  return {
    restrict: 'EA',
    replace: true,
    template: '<div class="barChart"></div>',
    scope: {
      data: '=',
      hovered: '&hovered',
      height: '=',
      width: '='
    },
    link: function(scope, elem, attrs) {

      scope.chart   = d3.custom.barChart(scope.options);
      scope.chartEl = d3.select(elem[0]);

      // scope.chart.on('customHover', function(d, i) {
      //   scope.hovered({args: d});
      // });

      scope.$watch('data', function(newVal, oldVal) {
        scope.chartEl.datum(newVal).call(scope.chart);
      }, true);

      scope.$watch('height', function(d, i) {
        scope.chartEl.call(scope.chart.height(scope.height));
      });

      scope.$watch('width', function(d, i) {
        scope.chartEl.call(scope.chart.width(scope.width));
      });
    }
  }
});