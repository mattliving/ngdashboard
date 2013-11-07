angular.module('luckyDashDirectives', ['luckyDashServices']);

angular.module('luckyDashDirectives').directive('metricTile', function() {
    return {
        restrict: 'E',
        scope: {
            title: '@',
            value: '=',
            columns: '@',
            width: '=',
            height: '='
        },
        templateUrl: "/views/metric-tile.html",
        link: function(scope, elem, attrs) {

            // scope.$watch('width', function(newVal, oldVal) {
            //     var $elem = angular.element(elem);
            //     $elem.find('h1').css({
            //     'font-size': function() { return (newVal + scope.height) / 30.82; }
            //     // left: function() { return newVal/2; },
            //     // width: function() { return newVal/2; }
            //     });
            //     $elem.find('h2').css({
            //     'font-size': function() { return (newVal + scope.height) / 39.625; }
            //     // left: function() { return newVal/2; },
            //     // width: function() { return newVal/2; }
            //     });
            // });

            // scope.$watch('height', function(newVal, oldVal) {
            //     var $elem = angular.element(elem);
            //     $elem.find('h1').css({
            //         'font-size': function() { return (newVal + scope.width) / 30.82; }
            //         // top: function() { return newVal/2; }
            //     });
            //     $elem.find('h2').css({
            //         'font-size': function() { return (newVal + scope.width) / 39.625; }
            //         // top: function() { return newVal/3; }
            //     });
            // });
        }
    };
});

angular.module('luckyDashDirectives').directive('graphTile', function() {
    return {
        restrict: 'E',
        scope: {
            ylabel: '=',
            data: '=',
            height: '=',
            width: '='
        },
        templateUrl: "/views/graph-tile.html",
        link: function(scope, elem, attrs) {}
    };
});

angular.module('luckyDashDirectives').directive('barChart', function() {
    return {
        restrict: 'EA',
        replace: true,
        template: '<div class="barChart"></div>',
        scope: {
            data: '=',
            ylabel: '=',
            hovered: '&hovered',
            height: '=',
            width: '='
        },
        link: function(scope, elem, attrs) {

            var options    = {};
            options.ylabel = scope.ylabel;
            scope.chart    = d3.custom.barChart(options);
            scope.chartEl  = d3.select(elem[0]);

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

/* Vertically center an element within its parent container */
angular.module('luckyDashDirectives').directive('vCentered', function($window) {
    return {
        restrict: 'A',
        link: function(scope, elem, attrs) {
            var parent = elem.parent();
            angular.element($window).bind('resize', function() {
                scope.$apply(function() {
                    elem.css('margin-top', function() {
                        var parentMid = parent.height()/2;
                        var elemMid   = elem.height()/2;
                        return (parentMid - elemMid - 2);
                    });
                });
            });
            angular.element($window).resize();
        }
    };
});