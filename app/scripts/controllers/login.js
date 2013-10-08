angular.module("luckyDashApp").controller("LoginCtrl", function($window, $scope, $routeParams) {

  angular.element('html').css('overflow', 'hidden');
  angular.element('body').css('overflow', 'hidden');

  $scope.height = 0;
  $scope.$watch('height', function(newVal, oldVal) {
    $('.login').css('margin-top', newVal/4);
  });
});