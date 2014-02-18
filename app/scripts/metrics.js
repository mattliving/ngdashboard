angular.module('luckyDashMetrics', []);
angular.module('luckyDashMetrics').factory('Metrics', function($q, Adwordsdaily, Opportunity) {

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

  Metric.prototype.toString = function() {
    return '[object Metric]';
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

  Metric.prototype.getTitle = function() {
    return this.title;
  }

  Metric.prototype.getValue = function() {
    return typeof this.value !== "undefined" ? this.value : null;
  }

  Metric.prototype.getPreviousValue = function() {
    return typeof this.previousValue !== "undefined" ? this.previousValue : null;
  }

  Metric.prototype.getType = function() {
    return this.type;
  }

  Metric.prototype.getTarget = function() {
    return this.hasTarget() ? this.options.target.value : null;
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
      type: "number",
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
      options: {
        target: {
          value: 200000,
          forecasted: false
        },
        comparison: 0
      }
    });
  }

  metrics.ad_cost = function() {
    return new Metric({
      title: 'Ad Cost',
      type: "number",
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
      options: {
        target: {
          value: 150000,
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
      type: "number",
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
      options: {
        target: {
          value: 50000,
          forecasted: false
        },
        comparison: 0
      }
    });
  }

  metrics.weighted_average_margin = function() {
    return new Metric({
      title: 'Margin',
      type: "percentage",
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
      options: {
        target: {
          value: 45,
          forecasted: true
        },
        progression: 0,
        comparison: 0
      }
    });
  }

  return metrics;
});