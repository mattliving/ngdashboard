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

    if (!(_.isEmpty(spec)) &&
        typeof spec.title !== "undefined" &&
        typeof spec.action !== "undefined" &&
        typeof spec.type !== "undefined") {
      _.extend(self, spec);
    }
  }

  Metric.prototype.hasTarget = function() {
    if (_.isEmpty(this.options)) return false;
    else return _.has(this.options, 'target');
  }

  Metric.prototype.hasComparison = function() {
    if (_.isEmpty(this.options)) return false;
    else return _.has(this.options, 'comparison');
  }

  Metric.prototype.hasProgressBar = function() {
    if (_.isEmpty(this.options)) return false;
    else return _.has(this.options, 'progression');
  }

  Metric.prototype.getType = function() {
    return this.type;
  }

  Metric.prototype.update = function(options) {
    var that = this;

    this.action(options).then(function(newValue) {
      that.value = newValue;

      if (that.hasProgressBar()) {
        that.getProgress(options).then(function(value) {
          that.options.progression = value;
        });
      }

      if (that.hasComparison()) {
        var date_from_moment  = moment(options.date_from);
        var date_to_moment    = moment(options.date_to);
        options.date_from     = date_from_moment.subtract('months', 1).format('YYYY-MM-DD HH:mm:ss');
        options.date_to       = date_to_moment.subtract('months', 1).format('YYYY-MM-DD HH:mm:ss');
        options.previousMonth = true;

        that.action(options).then(function(oldValue) {
          if (oldValue !== null && oldValue !== 0) {
            that.previousValue = oldValue;
            that.options.comparison = ((that.value - oldValue)/oldValue * 100);
          }
          else {
            that.previousValue = that.value;
            that.options.comparison = that.value;
          }
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
      type: "number",
      options: {
        target: {
          value: 20000,
          forecasted: false
        },
        comparison: 0
      }
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
      type: "number",
      options: {
        target: {
          value: 500,
          forecasted: true
        },
        comparison: 0
      }
    });
  }

  metrics.profit = function(others) {
    var revenue = others.revenue,
        margin  = others.margin,
        ad_cost = others.ad_cost;

    return new Metric({
      title: 'Profit',
      action: function(options) {
        var deferred = $q.defer();
        if (options.previousMonth) {
          deferred.resolve(revenue.previousValue * (margin.previousValue * 0.01) - ad_cost.previousValue);
        }
        else {
          deferred.resolve(revenue.value * (margin.value * 0.01) - ad_cost.value);
        }
        return deferred.promise;
      },
      type: "number",
      options: {
        target: {
          value: 10000,
          forecasted: false
        },
        comparison: 0
      }
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
      getProgress: function(options) {
        var deferred = $q.defer();

        Opportunity.get({
          email: options.email,
          action: 'margin_integrity',
          date_from: options.date_from,
          date_to: options.date_to
        }, function(opportunity) {
          deferred.resolve(opportunity['margin_integrity']);
        });

        return deferred.promise;
      },
      type: "percentage",
      options: {
        target: {
          value: 60,
          forecasted: true
        },
        progression: 0,
        comparison: 0
      }
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
