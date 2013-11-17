angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $scope, $routeParams, $http, $q, $timeout, Metrics, GraphActions) {

  $scope.formatGraphData = function(action, data) {

    var datetime, formattedData = [];
    _.each(data, function(d) {
      datetime = moment(d.date).utc();
      d.date   = datetime.format('YYYY-MM-DD');
      d.time   = datetime.format('HH:mm:ss');
      d.x      = datetime.date();
      if (action === 'monthly_revenue') d.y = d.revenue;
      else if (action === 'monthly_ad_cost') d.y = d.ad_cost;
      formattedData.push({
        'x': d.x,
        'y': d.y
      });
    });
    switch (action) {
      case "monthly_revenue":
        formattedData = [];
        _.map(_.groupBy(data, function(m) { return m.x; }),
          function(array) {
            formattedData.push({
              'x': _.first(array).x,
              'y': _.reduce(array, function(memo, obj) { return memo + obj.revenue; }, 0)
            });
          });
        return formattedData;
      case "monthly_ad_cost":
        return formattedData;
    }
  }

  var revenue        = Metrics['revenue']();
  var ad_cost        = Metrics['ad_cost']();
  var profit         = Metrics['profit'](revenue, ad_cost);
  var average_margin = Metrics['weighted_average_margin']();
  $scope.metrics = [
    revenue, ad_cost, profit, average_margin
  ];

  // $scope.graphs = [
  //   {
  //     ylabel: 'Revenue',
  //     action: 'monthly_revenue',
  //     data: []
  //   },
  //   {
  //     ylabel: 'Ad Cost',
  //     action: 'monthly_ad_cost',
  //     data: []
  //   }
  // ];

  /* Loop through and request metric data */
  $scope.updateMetrics = function(metrics) {

    _.each(metrics, function(metric) {
      var options = {
        acid: $scope.account.acid,
        email: $scope.account.email,
        date_from: $scope.date_from,
        date_to: $scope.date_to
      };
      metric.update(options);
    });
  }

  /* Loop through and request graph data */
  $scope.updateGraphs = function(graphs) {

    var options = {};
    options.acid            = $scope.account.acid;
    options.email           = $scope.account.email;
    options.date_from       = $scope.date_from;
    options.date_to         = $scope.date_to;
    options.formatGraphData = $scope.formatGraphData;

    _.each(graphs, function(graph) {
      GraphActions[graph.action](graph, options).then(function(data) {
        graph.data = data;
      });
    });
  }

  $scope.updateTime = function() {
    $scope.date_from = moment().utc().date(1).hour(0).minute(0).second(0).format('YYYY-MM-DD HH:mm:ss');
    $scope.date_to   = moment().utc().format('YYYY-MM-DD HH:mm:ss');
  }

  $scope.account = {};
  $scope.account.email = $routeParams.email;

  /* Find the acid for the current account by email */
  $http.get('/api/v1/customers/' + $scope.account.email + '/id')
  .success(function(obj) {

    $scope.account.acid = obj.acid;

    /* Load in the data on page load and periodically every
     5 seconds thereafter */
    var updateInterval = 5000;
    $scope.updateTime();
    $scope.updateMetrics($scope.metrics);
    $scope.updateGraphs($scope.graphs);
    $timeout(function update() {
      $scope.updateTime();
      $scope.updateMetrics($scope.metrics);
      $scope.updateGraphs($scope.graphs);
      $timeout(update, updateInterval);
    }, updateInterval);
  })
  .error(function() { console.log("Unable to find account id for " + $scope.account.email + "."); });

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    $scope.tileWrapperHeight  = newVal;//newVal/3;
    // $scope.graphWrapperHeight = newVal*(2/3);
    $('.tileWrapper').height($scope.tileWrapperHeight);
  });

  // $scope.$watch('width', function(newVal, oldVal) {
  //   console.log(newVal);
  // });
});
