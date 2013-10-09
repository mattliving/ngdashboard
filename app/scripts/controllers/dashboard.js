angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $scope, $routeParams, $timeout, Opportunity) {

  var email = $routeParams.email;

  $scope.metrics = [
    {
      title: 'Total Revenue',
      action: 'total_revenue',
      value: 0
    },
    {
      title: 'Total Revenue',
      action: 'total_revenue',
      value: 0
    }
  ];

  //   {
  //     title: 'Ad Cost',
  //     action: 'ad_cost',
  //     value: 0
  //   }
  $scope.graphs = [
    {
      title: 'Revenue Over Time',
      action: 'revenue_over_time',
      data: []
    },
    {
      title: 'Revenue Over Time',
      action: 'revenue_over_time',
      data: []
    }
  ];

  /* Function to loop through and request metric data */
  $scope.updateMetrics = function(metrics) {
    _.each(metrics, function(metric) {
      Opportunity.get({
        email: email,
        action: metric.action,
        date_from: $scope.date_from,
        date_to: $scope.date_to
      }, function(opportunity) {
        metric.value = opportunity[metric.action];
      });
    });
  }

  $scope.updateGraphs = function(graphs) {
    _.each(graphs, function(graph) {
      Opportunity.query({
        email: email,
        action: graph.action,
        date_from: $scope.date_from,
        date_to: $scope.date_to
      }, function(opportunity) {
        graph.data = formatGraphData(opportunity);
      });
    });
  }

  /* Load in the data on page load and periodically every
     5 seconds thereafter */
  // var counter = 11;
  // var counter2 = 12;
  var updateInterval = 5000;
  (function() {
    $scope.date_from = moment().utc().date(1).hour(0).minute(0).second(0).format('YYYY-MM-DD HH:mm:ss');
    $scope.date_to   = moment().utc().format('YYYY-MM-DD HH:mm:ss');
    $scope.updateMetrics($scope.metrics);
    $scope.updateGraphs($scope.graphs);
    $timeout(function update() {
      $scope.date_from = moment().utc().date(1).hour(0).minute(0).second(0).format('YYYY-MM-DD HH:mm:ss');
      $scope.date_to   = moment().utc().format('YYYY-MM-DD HH:mm:ss');
      $scope.updateMetrics($scope.metrics);
      $scope.updateGraphs($scope.graphs);
      // console.log($scope.graphs);
      // $scope.graphs[0].data.push(counter++);
      // $scope.graphs[1].data.push(counter2);
      // counter2 = counter2 + 2;
      $timeout(update, updateInterval);
    }, updateInterval);
  })(updateInterval);

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    $scope.tileWrapperHeight  = newVal/3;
    $scope.graphWrapperHeight = newVal*(2/3);
    $('.tileWrapper').height($scope.tileWrapperHeight);
  });

  function formatGraphData(data) {
    var temp;
    _.each(data, function(d) {
      temp   = moment(d.date).utc();
      d.date = temp.format('YYYY-MM-DD');
      d.time = temp.format('HH:mm:ss');
      d.x = temp.date();
      d.y = d.revenue;
      // console.log(d);
    });
    formattedData = [];
    _.map(_.groupBy(data, function(m) { return m.x; }),
      function(array) {
        formattedData.push({
          'x': _.first(array).x,
          'y': _.reduce(array, function(memo, obj) { return memo + obj.revenue; }, 0)
        });
      });
    // console.log(formattedData);
    return formattedData;
  }
});
