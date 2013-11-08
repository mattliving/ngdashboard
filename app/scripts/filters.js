angular.module('luckyDashFilters', []);

angular.module('luckyDashFilters').filter('join', function() {
  return function(array) {
    if (array != null) {
      return array.join(', ');
    }
  };
});

angular.module('luckyDashFilters').filter('round', function() {
  return function(number, places) {
    if (number !== null && typeof number !== 'undefined') {
      if (places !== null && typeof places !== 'undefined') {
        return Math.round(number * Math.pow(10, places))/Math.pow(10, places);
      }
      else return Math.round(number);
    }
  };
});
