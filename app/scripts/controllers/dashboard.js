angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $scope, $routeParams, $http, $timeout, MetricActions, GraphActions) {

  $scope.formatGraphData = function(data) {
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

  $scope.metrics = [
    {
      title: 'Total Revenue',
      action: 'total_revenue',
      value: 0
    },
    {
      title: 'Total Ad Cost',
      action: 'total_ad_cost',
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
    }
    // {
    //   title: 'Revenue Over Time',
    //   action: 'revenue_over_time',
    //   data: []
    // }
  ];

  /* Loop through and request metric data */
  $scope.updateMetrics = function(metrics) {

    var options = {};
    options.acid      = $scope.account.acid;
    options.email     = $scope.account.email;
    options.date_from = $scope.date_from; //'2013-09-01';
    options.date_to   = $scope.date_to; //'2013-09-30';

    _.each(metrics, function(metric) {
      MetricActions[metric.action](metric, options);
    });
  }

  /* Loop through and request graph data */
  $scope.updateGraphs = function(graphs) {

    var options = {};
    options.acid            = $scope.account.acid;
    options.email           = $scope.account.email;
    options.date_from       = $scope.date_from; //'2013-09-01';
    options.date_to         = $scope.date_to; //'2013-09-30';
    options.formatGraphData = $scope.formatGraphData;

    _.each(graphs, function(graph) {
      GraphActions[graph.action](graph, options);
    });
  }

  $scope.updateTime = function() {
    $scope.date_from = moment().utc().date(1).hour(0).minute(0).second(0).format('YYYY-MM-DD HH:mm:ss');
    $scope.date_to   = moment().utc().format('YYYY-MM-DD HH:mm:ss');
  }

  $scope.account = {};
  $scope.account.email = $routeParams.email;

  $http.get('/api/v1/customers/' + $scope.account.email + '/id')
  .success(function(obj) {

    $scope.account.acid = obj.acid;

    /* Load in the data on page load and periodically every
     5 seconds thereafter */
    // var counter = 11;
    // var counter2 = 12;
    var updateInterval = 5000;
    $scope.updateTime();
    $scope.updateMetrics($scope.metrics);
    $scope.updateGraphs($scope.graphs);
    $timeout(function update() {
      $scope.updateTime();
      // $scope.updateMetrics($scope.metrics);
      // $scope.updateGraphs($scope.graphs);
      // console.log($scope.graphs);
      // $scope.graphs[0].data.push(counter++);
      // $scope.graphs[1].data.push(counter2);
      // counter2 = counter2 + 2;
      $timeout(update, updateInterval);
    }, updateInterval);
  })
  .error(function() { console.log("Unable to find account id for " + $scope.account.email + "."); });

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    $scope.tileWrapperHeight  = newVal/3;
    $scope.graphWrapperHeight = newVal*(2/3);
    $('.tileWrapper').height($scope.tileWrapperHeight);
  });
});
