angular.module('luckyDashFilters', []);

angular.module('luckyDashFilters').filter('join', function() {
  return function(array) {
    if (array != null) {
      return array.join(', ');
    }
  };
});
