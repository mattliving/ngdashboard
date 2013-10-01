angular.module("luckyDashApp").controller("DashboardCtrl", function($window, $http, $scope) {

  // console.log($window.height);
  // console.log(angular.element('#tileWrapper').height());
  // angular.element('#tileWrapper').height($window.height/3);
  // angular.element('#graphWrapper').height($window.height/1.5);

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    console.log(newVal);
    console.log($('.tileWrapper').height());
    $('.tileWrapper').height(newVal/3);
    console.log($('.tileWrapper').height());
    $('.graphWrapper').height(newVal/1.5);
  });

  $scope.tiles = [
    {
      title: 'First',
      metric: '67%'
    },
    {
      title: 'Second',
      metric: '67%'
    },
    {
      title: 'Third',
      metric: '67%'
    },
    {
      title: 'Fourth',
      metric: '67%'
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
});
