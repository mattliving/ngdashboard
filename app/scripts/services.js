angular.module('luckyDashServices', []);

angular.module('luckyDashServices').factory('dashify', function() {
  return function(string) {
    return string != null ? string.replace(/-/g, " ").split(" ").map(function(word) {
      return word.replace(/\W/g, '').toLowerCase();
    }).join("-") : void 0;
  };
});

angular.module('luckyDashServices').factory('ga-adcost', function($window) {

}).factory('Customer', function($resource) {
  return $resource('api/v1/customers/:email/id', {email: '@email'}, {update: {method: "PUT"}});
}).factory('Opportunity', function($resource) {
  return $resource('api/v1/opportunities/:oid', {oid: '@oid'}, {update: {method: "PUT"}});
})
.factory('Adwordsdaily', function($resource) {
  return $resource('api/v1/adwordsdaily/:acid', {acid: '@acid'}, {update: {method: "PUT"}});
});
