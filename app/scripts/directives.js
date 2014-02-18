angular.module('luckyDashDirectives', ['luckyDashServices']);

function isFalsy(d) {
    return _.isNull(d) || _.isUndefined(d) || _.isNaN(d) || d === 0;
};

angular.module('luckyDashDirectives').directive('metricTile', function() {
    return {
        restrict: 'E',
        scope: {
            title: '@',
            type: '@',
            value: '=',
            options: '=',
            columns: '@',
            width: '=',
            height: '='
        },
        templateUrl: "/views/metric-tile.html",
        link: function(scope, elem, attrs) {

            var opts = scope.options;

            scope.has = function(attr) {
                if (_.isEmpty(opts)) return false;
                else return _.has(opts, attr);
            }

            /* Getters */
            scope.hasTarget      = function() { return scope.has('target'); }// || scope.value == 0 ? false : true;
            scope.hasComparison  = function() { return scope.has('comparison'); }
            scope.hasProgressBar = function() { return scope.has('progression'); }

            /* Helpers */
            scope.isForecasted = function() {
                if (!scope.hasTarget()) return false;
                else return opts.target.forecasted;
            }

            scope.percentToTarget = function() {
                return (scope.value/opts.target.value)*100;
            }

            scope.averagePerDay = function() {
                return ((scope.value / moment().utc().date()) * moment().utc().daysInMonth()) / opts.target.value * 100;
                // return ((scope.value / moment(opts.date_to).utc().date()) * moment(opts.date_to).utc().daysInMonth()) / opts.target.value * 100;
            }

            var fontBench = {
                width : 1440,
                pixels: 21,
                ratio: 0.01458
            };

            function resize(width) {
                var diff = width - fontBench.width;
                return diff * fontBench.ratio + fontBench.pixels;
            }

            scope.$watch('width', function(newVal, oldVal) {
                var $elem = angular.element(elem);
                $elem.find('.body').css('font-size', resize(newVal));
            });

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

angular.module('luckyDashDirectives').directive('graphTile', function($compile) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            data: '=',
            type: '=',
            ylabel: '=',
            height: '=',
            width: '='
        },
        templateUrl: "/views/graph-tile.html",
        link: function(scope, elem, attrs) {
            scope.$watch('type', function(newVal, oldVal) {
                var html = elem.html();
                html = html.replace('<div', function() {
                    return '<div ' + newVal + '-chart';
                });
                elem.html(html);
                $compile(elem.contents())(scope);
            });

            scope.$watch('height', function(newVal, oldVal) {
                elem.height(newVal);
            });
        }

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

angular.module('luckyDashDirectives').directive('bulletChart', function() {
    return {
        restrict: 'EA',
        replace: true,
        template: '<div class="bulletChart"></div>',
        scope: {
            data: '=',
            ylabel: '=',
            hovered: '&hovered',
            height: '=',
            width: '='
        },
        link: function(scope, elem, attrs) {

            var options   = {};
            scope.chart   = d3.custom.bulletChart(options);
            scope.chartEl = d3.select(elem[0]);

            scope.$watch('data', function(newVal, oldVal) {

                if (_.chain(newVal)
                    .has('ranges')
                    .has('measures')
                    .has('markers')) {

                    if (!(_.some(newVal.ranges, isFalsy) ||
                    _.some(newVal.measures, isFalsy) ||
                    _.some(newVal.markers, isFalsy))) {
                        scope.chartEl.datum(newVal).call(scope.chart);
                    }
                }
            }, true);

            scope.$watch('height', function(newVal, oldVal) {
                scope.chartEl.call(scope.chart.height(newVal));
            });

            scope.$watch('width', function(newVal, oldVal) {
                scope.chartEl.call(scope.chart.width(newVal));
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

angular.module('luckyDashDirectives').directive('vCenter', function($window, $document, $rootScope) {
    return {
        restrict: 'A',
        scope: true,
        link: function(scope, elem, attrs) {

            var $elem   = angular.element(elem);
            var $parent = elem.parent();
            scope.minFontSize = attrs.min || Number.NEGATIVE_INFINITY;
            scope.maxFontSize = attrs.max || Number.POSITIVE_INFINITY;

            function absoluteFix() {
                if (typeof attrs.top !== "undefined") {
                    elem.css('margin-top', function() {
                        return ((attrs.top/100) * $parent.height()) + 'px';
                    });
                }
            }

            function resizeText() {
                elem.height($parent.height() * (attrs.height/100));
                if (typeof attrs.height !== "undefined") {
                    elem.css('font-size', function() {
                        return elem.height() * 1;
                    });
                    elem.css('line-height', function() {
                        return (elem.height() * 1) + 'px';
                    });
                }
            }

            $rootScope.$on('windowResizeEventFired', function() {
                absoluteFix();
                resizeText();
            });
        }
    };
});

angular.module('luckyDashDirectives').directive('fitText', ['$document', '$rootScope', function($document, $rootScope) {
    return {
        restrict: 'A',
        scope: true,
        link: function($scope, $element, $attrs) {
            $scope.compressor  = $attrs.compressor || 1;
            $scope.minFontSize = $attrs.min || Number.NEGATIVE_INFINITY;
            $scope.maxFontSize = $attrs.max || Number.POSITIVE_INFINITY;

            function resizer() {
                $scope.fontSize = Math.max(
                    Math.min(
                        $element[0].offsetWidth / ($scope.compressor * 10),
                        parseFloat($scope.maxFontSize)
                    ),
                    parseFloat($scope.minFontSize)
                ) + 'px';
            };

            $rootScope.$on('windowResizeEventFired', function() {
                resizer();
            });

            $document.ready(function() {
                resizer();
            });
        }
    }
}]);

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
            var parentMid = parent.height() / heightDivisor;
            var elemMid   = elem.height() / heightDivisor;
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