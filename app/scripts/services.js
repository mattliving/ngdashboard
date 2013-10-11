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
});

angular.module('luckyDashServices').factory('MetricActions', function($http, Opportunity) {

  var metricActions = {};

  metricActions.total_revenue = function(metric, options) {
    Opportunity.get({
      email: options.email,
      action: metric.action,
      date_from: options.date_from,
      date_to: options.date_to
    }, function(opportunity) {
      metric.value = opportunity[metric.action];
    });
  }

  metricActions.total_ad_cost = function(metric, options) {
    var url = '/api/v1/adwords/' + options.acid + '?date=' + moment(options.date_to).format('YYYY-MM-DD');
    console.log(url);
    $http.get(url).success(function(data) {
      console.log(data);
    }).error(function(err) {
      console.log("ERROR");
    });
  }

  return metricActions;
});

angular.module('luckyDashServices').factory('GraphActions', function(Opportunity) {

  var graphActions = {};

  graphActions.revenue_over_time = function(graph, options) {
    Opportunity.query({
      email: options.email,
      action: graph.action,
      date_from: options.date_from,
      date_to: options.date_to
    }, function(opportunity) {
      graph.data = options.formatGraphData(opportunity);
    });
  }

  return graphActions;
});
