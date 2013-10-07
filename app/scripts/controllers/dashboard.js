angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $scope, $routeParams, $timeout, Opportunity) {

  var acid = $routeParams.acid;

  /* Function to loop through and request metric data */
  $scope.updateMetrics = function(metrics) {
    $scope.date_from = moment().utc().date(1).hour(0).minute(0).second(0).format('YYYY-MM-DD HH:mm:ss');
    $scope.date_to   = moment().utc().format('YYYY-MM-DD HH:mm:ss');
    _.each(metrics, function(metric) {
      Opportunity.get({
        acid: acid,
        action: metric.action,
        date_from: $scope.date_from,
        date_to: $scope.date_to
      }, function(opportunity) {
        metric.value = opportunity[metric.action];
      });
    });
  }

  $scope.metrics = [
    {
      title: 'Total Revenue',
      action: 'total_revenue',
      value: 0
    }
  ];

  // ,
  //   {
  //     title: 'Google Spend',
  //     action: 'google_spend',
  //     value: 0
  //   },
  //   {
  //     title: 'ROI',
  //     action: 'roi',
  //     value: 0
  //   },
  //   {
  //     title: 'Ad Cost',
  //     action: 'ad_cost',
  //     value: 0
  //   }
  $scope.graphs = [
    {
      title: 'Graph One',
      data: [0,1,2,3,4]
    },
    {
      title: 'Graph Two',
      data: [1,3,5,7,9]
    },
    {
      title: 'Graph Three',
      data: [1.5,3.0,4.5,6.0,7.5]
    }
  ];

  /* Load in the data on page load and periodically every
     5 seconds thereafter */
  (function() {
    $scope.updateMetrics($scope.metrics);
    $timeout(function update() {
      $scope.updateMetrics($scope.metrics);
      $timeout(update, 5000);
    }, 5000);
  })();

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    $scope.tileWrapperHeight  = newVal/3;
    $scope.graphWrapperHeight = newVal*(2/3);
    $('.tileWrapper').height($scope.tileWrapperHeight);
    // $('.graphWrapper').height($scope.graphWrapperHeight);
  });

  // $scope.$watch('width', function(newVal, oldVal) {
  //   $scope.graphWrapperWidth = newVal;
  // }
});
