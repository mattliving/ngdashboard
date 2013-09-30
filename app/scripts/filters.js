angular.module('luckyDashAppFilters', []);

angular.module('luckyDashAppFilters').filter('join', function() {
  return function(array) {
    if (array != null) {
      return array.join(', ');
    }
  };
});
