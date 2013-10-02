angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $scope, $routeParams, Opportunity) {

  var acid         = $routeParams.acid;
  $scope.date_from = '2013-09-01';
  $scope.date_to   = '2013-09-30';

  /* Function to loop through and request metric date */
  $scope.updateMetrics = function(metrics) {
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
    },
    {
      title: 'Google Spend',
      action: 'google_spend',
      value: 0
    },
    {
      title: 'ROI',
      action: 'roi',
      value: 0
    },
    {
      title: 'Ad Cost',
      action: 'ad_cost',
      value: 0
    }
  ];
  $scope.graphs = [
    {
      title: 'Graph One'
    },
    {
      title: 'Graph Two'
    }
  ];

  $window.setInterval($scope.updateMetrics($scope.metrics), 60000);

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    $('.tileWrapper').height(newVal/3);
    $('.graphWrapper').height(newVal/1.5);
  });
});
