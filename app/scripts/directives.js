angular.module('luckyDashDirectives', ['luckyDashServices']);

angular.module('luckyDashDirectives').directive('metricTile', function() {
    return {
        restrict: 'E',
        scope: {
            title: '@',
            value: '=',
            comparison: '=',
            target: '=',
            columns: '@',
            width: '=',
            height: '='
        },
        templateUrl: "/views/metric-tile.html",
        link: function(scope, elem, attrs) {

            scope.hasComparison = function() {
                return typeof scope.comparison === "undefined" ? false : true;
            }

            scope.hasTarget = function() {
                return (typeof scope.target === "undefined")
                        || (scope.value == 0)
                        ? false : true;
            }

            scope.percentToTarget = function() {
                return (scope.value/scope.target)*100;
            }

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

angular.module('luckyDashDirectives').directive('resize', function($window, $rootScope) {
    return function (scope) {
        scope.width  = $window.innerWidth;
        scope.height = $window.innerHeight;
        angular.element($window).bind('resize', function() {
            scope.$apply(function() {
                scope.width  = $window.innerWidth;
                scope.height = $window.innerHeight;
                $rootScope.$broadcast('windowResizeEventFired');
            });
        });
    };
});

/* Vertically position an element within its parent container */
angular.module('luckyDashDirectives').directive('vAnchor', function($window, $rootScope) {
    return {
        restrict: 'A',
        link: function(scope, elem, attrs) {

            var heightDivisor;
            var operand = 'minus';
            var offset  = 2;
            switch (attrs.height) {
                case 'centered':
                    heightDivisor = 2;
                    break;
                case 'top-third':
                    heightDivisor = 3;
                    break;
                case 'bottom-third':
                    heightDivisor = 3;
                    operand = 'plus';
                    break;
                case 'top-quarter':
                    heightDivisor = 4;
                    break;
                case 'bottom-quarter':
                    heightDivisor = 4;
                    operand = 'plus';
                    break;
                case 'undefined':
                    heightDivisor = 2;
                    break;
                default:
                    break;
            }
            var parent    = elem.parent();
            var parentMid = parent.height()/heightDivisor;
            var elemMid   = elem.height()/heightDivisor;
            elem.css('margin-top', function() {
                if (operand === 'minus')
                    return (parentMid - elemMid - offset);
                else return (parentMid + elemMid + offset)
            });

            $rootScope.$on('windowResizeEventFired', function() {
                elem.css('margin-top', function() {
                    if (operand === 'minus')
                        return (parentMid - elemMid - offset);
                    else return (parentMid + elemMid + offset)
                });
            });
        }
    };
});