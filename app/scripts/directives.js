
angular.module('luckyDashAppDirectives', ['luckyDashAppServices']);

angular.module('luckyDashAppDirectives').directive('inviteForm', function() {
  return {
    restrict: 'E',
    scope: {
      show: '='
    },
    templateUrl: "/views/invite-form.html",
    link: function(scope, elem, attrs) {
      var _ref;
      return (_ref = scope.show) != null ? _ref : scope.show = true;
    }
  };
});
