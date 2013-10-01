
angular.module('luckyDashServices', []);

angular.module('luckyDashServices').factory('dashify', function() {
  return function(string) {
    return string != null ? string.replace(/-/g, " ").split(" ").map(function(word) {
      return word.replace(/\W/g, '').toLowerCase();
    }).join("-") : void 0;
  };
});

angular.module('luckyDashServices').factory('resize', function($window) {
  var $w = angular.element($window);

});
