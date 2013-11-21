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

angular.module('luckyDashServices').factory('Metrics', function($q, Adwordsdaily, Opportunity) {

  function Metric(spec) {
    var self = this instanceof Metric
             ? this
             : Object.create(Metric.prototype);

    if (typeof !(_.isEmpty(spec)) &&
        typeof spec.title !== "undefined" &&
        typeof spec.action !== "undefined" &&
        typeof spec.type !== "undefined") {
      _.extend(self, spec);
    }
  }

  Metric.prototype.hasTarget = function() {
    return typeof this.target === "undefined" ? false : true;
  }

  Metric.prototype.hasComparison = function() {
    return typeof this.comparison === "undefined" ? false : true;
  }

  Metric.prototype.hasProgressBar = function() {
    return typeof this.progressBar === "undefined" ? false : true;
  }

  Metric.prototype.getType = function() {
    return this.type;
  }

  Metric.prototype.update = function(options) {
    var that = this;

    this.action(options).then(function(newValue) {
      that.value = newValue;

      if (that.hasComparison()) {
        var date_from_moment = moment(options.date_from);
        var date_to_moment   = moment(options.date_to);
        options.date_from    = date_from_moment.subtract('months', 1).format('YYYY-MM-DD HH:mm:ss');
        options.date_to      = date_to_moment.subtract('months', 1).format('YYYY-MM-DD HH:mm:ss');

        that.action(options).then(function(oldValue) {
          if (oldValue !== null && oldValue !== 0) {
            that.comparison = ((that.value - oldValue)/oldValue * 100);
          }
          else that.comparison = that.value;
        });
      }
    });
  }

  var metrics = {};

  metrics.revenue = function() {
    return new Metric({
      title: 'Revenue',
      action: function(options) {
        var deferred = $q.defer();

        Opportunity.get({
          email: options.email,
          action: 'total_revenue',
          date_from: options.date_from,
          date_to: options.date_to
        }, function(opportunity) {
          deferred.resolve(opportunity['total_revenue']);
        });

        return deferred.promise;
      },
      target: 20000,
      type: "number",
      comparison: 0
    });
  }

  metrics.ad_cost = function() {
    return new Metric({
      title: 'Ad Cost',
      action: function(options) {
        var deferred = $q.defer();

        Adwordsdaily.get({
          acid: options.acid,
          action: 'total_ad_cost',
          date_from: options.date_from,
          date_to: options.date_to
        }, function(total) {
          deferred.resolve(total['total_ad_cost']);
        });

        return deferred.promise;
      },
      target: 500,
      type: "number",
      comparison: 0
    });
  }

  metrics.profit = function(revenue, ad_cost) {
    return new Metric({
      title: 'Profit',
      action: function() {
        var deferred = $q.defer();
        deferred.resolve(revenue.value - ad_cost.value);
        return deferred.promise;
      },
      target: 10000,
      type: "number"
    });
  }

  metrics.weighted_average_margin = function() {
    return new Metric({
      title: 'Margin',
      action: function(options) {
        var deferred = $q.defer();

        Opportunity.get({
          email: options.email,
          action: 'weighted_average_margin',
          date_from: options.date_from,
          date_to: options.date_to
        }, function(opportunity) {
          deferred.resolve(opportunity['weighted_average_margin']);
        });

        return deferred.promise;
      },
      target: 60,
      type: "percentage",
      comparison: 0,
      progressBar: true
    });
  }

  return metrics;
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
      var formatted = options.formatGraphData(graph.action, data);
      deferred.resolve(formatted);
    });

    return deferred.promise;
  }

  return graphActions;
});
