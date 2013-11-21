angular.module('luckyDashDirectives', ['luckyDashServices']);

angular.module('luckyDashDirectives').directive('metricTile', function() {
    return {
        restrict: 'E',
        scope: {
            title: '@',
            value: '=',
            target: '=',
            type: '@',
            comparison: '=',
            progressBar: '=',
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

            scope.hasProgressBar = function() {
                return typeof scope.progressBar === "undefined" ? false : true;
            }

            scope.percentToTarget = function() {
                return (scope.value/scope.target)*100;
            }

            scope.averagePerDay = function() {
                return ((scope.value / moment().utc().date()) * moment().utc().daysInMonth()) / scope.target * 100;
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

            // scope.$watch('data', function(newVal, oldVal) {
            //     scope.chartEl.datum(newVal).call(scope.chart);
            // }, true);

            // scope.$watch('height', function(d, i) {
            //     scope.chartEl.call(scope.chart.height(scope.height));
            // });

            // scope.$watch('width', function(d, i) {
            //     scope.chartEl.call(scope.chart.width(scope.width));
            // });
            d3.json("bullets.json", function(error, data) {
                var svg = d3.select("body").selectAll("svg")
                    .data(data)
                    .enter().append("svg")
                        .attr("class", "bullet")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                    .append("g")
                        .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
                    .call(chart);

                var title = svg.append("g")
                    .style("text-anchor", "end")
                    .attr("transform", "translate(-6," + height / 2 + ")");

                title.append("text")
                    .attr("class", "title")
                    .text(function(d) { return d.title; });

                title.append("text")
                    .attr("class", "subtitle")
                    .attr("dy", "1em")
                    .text(function(d) { return d.subtitle; });

                d3.selectAll("button").on("click", function() {
                    svg.datum(randomize).call(chart.duration(1000)); // TODO automatic transition
                });
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


angular.module('luckyDashDirectives').directive('multiRepeat', function() {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {
      active: '=',
      columns: '@',
      collection: '=',
      dragging: '&dragging'
    },
    template: ["<div class='row multi-items' ng-repeat='(index, items) in set'>",
                "<div class='col-xs-{{12/columns}} multi-item' ng-repeat='item in items'>",
                "<div ng-transclude></div>",
                "</div>",
                "</div>"].join(""),
    link: function(scope, elem, attrs) {
      scope.$multiParent = scope.$parent;
      scope.$watchCollection('collection', function() {
        return scope.set = _.groupBy(scope.collection, function(item) {
          var index;
          return index = Math.floor((_.indexOf(scope.collection, item)) / scope.columns);
        });
      });
      scope.calcIndex = function(index, parent) {
        return parseInt(parent.index) * scope.columns + index;
      };
    }
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
                // if (typeof attrs.top !== "undefined") {
                //     elem.css('top', attrs.top);
                // }
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

            $document.ready(function() {
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