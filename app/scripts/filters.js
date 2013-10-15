angular.module('luckyDashFilters', []);

angular.module('luckyDashFilters').filter('join', function() {
  return function(array) {
    if (array != null) {
      return array.join(', ');
    }
  };
});

angular.module('luckyDashFilters').filter('round', function() {
  return function(number) {
    if (number !== null && typeof number !== 'undefined') {
      return Math.round(number)
    }
  };
});
