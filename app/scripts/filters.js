angular.module('luckyDashFilters', []);

angular.module('luckyDashFilters').filter('join', function() {
  return function(array) {
    if (array != null) {
      return array.join(', ');
    }
  };
});

angular.module('luckyDashFilters').filter('typeFormat', function() {
  return function(value, type) {
    if (typeof type !== "undefined") {
      switch (type) {
        case "number":
          return '£' + value;
          break;
        case "percentage":
          return value + '%';
          break;
        default:
          break;
      }
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
