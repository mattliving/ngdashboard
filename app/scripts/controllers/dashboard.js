angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $location, $scope, $rootScope, $routeParams, $http, $q, $timeout, Metrics, Graphs) {

  $http.get($routeParams.email + '/dashboard/verify').success(function(res) {
    var revenue = Metrics['revenue']();
    var ad_cost = Metrics['ad_cost']();
    var margin  = Metrics['weighted_average_margin']();
    var profit  = Metrics['profit']({
      revenue: revenue,
      margin: margin,
      ad_cost: ad_cost
    });

    $scope.metrics = [
      revenue, ad_cost, profit, margin
    ];

    $scope.graphs = [
      Graphs.revenue({metric: revenue, type: 'bullet'}),
      Graphs.ad_cost({metric: ad_cost, type: 'bullet'}),
      Graphs.profit({metric: profit, type: 'bullet'}),
      Graphs.margin({metric: margin, type: 'bullet'})
    ]

    // $scope.graphs = [
    //   Graphs.revenue({metric: revenue, type: 'bar'})
    // ]

    /* Update a collection of metrics or graphs */
    $scope.update = function(collection) {
      _.each(collection, function(item) {
        if (item.toString() === '[object Metric]'
          || item.toString() === '[object Graph]') {
          var options = {
            acid: $scope.account.acid,
            email: $scope.account.email,
            date_from: $scope.date_from,
            date_to: $scope.date_to
          };
          item.options.date_from = options.date_from;
          item.options.date_to   = options.date_to;
          item.update(options);
        }
        else console.error('Requires a collection of type Metric or Graph.');
      });
    }

    $scope.updateTime = function() {
      $scope.date_from = '2013-11-01'; //moment().utc().date(1).hour(0).minute(0).second(0).format('YYYY-MM-DD HH:mm:ss');
      $scope.date_to   = '2013-11-30'; //moment().utc().format('YYYY-MM-DD HH:mm:ss');
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
      $scope.update($scope.metrics);
      $scope.update($scope.graphs);
      $timeout(function update() {
        $scope.updateTime();
        $scope.update($scope.metrics);
        $scope.update($scope.graphs);
        $timeout(update, updateInterval);
      }, updateInterval);
    })
    .error(function() { console.log("Unable to find account id for " + $scope.account.email + "."); });

    $scope.$watch('height', function(newVal, oldVal) {
      $scope.tileWrapperHeight  = newVal/3;
      $scope.graphWrapperHeight = newVal*(2/3);
      $('.tileWrapper').height($scope.tileWrapperHeight);
      $('.graphWrapper').height($scope.graphWrapperHeight);
      $rootScope.$broadcast('windowResizeEventFired');
    });
  }).error(function(res) {
    $location.path('/login');
  });
});
