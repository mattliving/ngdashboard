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

angular.module('luckyDashServices').factory('MetricActions', function($q, Adwordsdaily, Opportunity) {

  var metricActions = {};

  metricActions.total_revenue = function(metric, options) {
    var deferred = $q.defer();

    Opportunity.get({
      email: options.email,
      action: metric.action,
      date_from: options.date_from,
      date_to: options.date_to
    }, function(opportunity) {
      deferred.resolve(opportunity[metric.action]);
    });

    return deferred.promise;
  }

  metricActions.total_ad_cost = function(metric, options) {
    var deferred = $q.defer();

    Adwordsdaily.get({
      acid: options.acid,
      action: metric.action,
      date_from: options.date_from,
      date_to: options.date_to
    }, function(total) {
      deferred.resolve(total[metric.action]);
    });

    return deferred.promise;
  }

  return metricActions;
});

angular.module('luckyDashServices').factory('GraphActions', function($window, $q, Adwordsdaily, Opportunity) {

  var graphActions = {};

  graphActions.monthly_revenue = function(graph, options) {
    var deferred = $q.defer();

    Opportunity.query({
      email: options.email,
      action: graph.action,
      date_from: options.date_from,
      date_to: options.date_to
    }, function(data) {
      var formatted = options.formatGraphData(graph.action, data)
      deferred.resolve(formatted);
    });

    return deferred.promise;
  }

  graphActions.monthly_ad_cost = function(graph, options) {
    var deferred = $q.defer();

    Adwordsdaily.query({
      acid: options.acid,
      action: graph.action,
      date_from: options.date_from,
      date_to: options.date_to
    }, function(data) {
      console.log(data);
      var formatted = options.formatGraphData(graph.action, data);
      console.log(formatted);
      deferred.resolve(formatted);
    });

    return deferred.promise;
  }

  return graphActions;
});
