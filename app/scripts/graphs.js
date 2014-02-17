angular.module('luckyDashGraphs', []);
angular.module('luckyDashGraphs').factory('Graphs', function($q, Adwordsdaily, Opportunity) {

  function Graph(spec) {
    var self = this instanceof Graph
             ? this
             : Object.create(Graph.prototype);

    if (!(_.isEmpty(spec)) &&
        typeof spec.ylabel !== "undefined" &&
        typeof spec.action !== "undefined") {
      _.extend(self, spec);
    }
  }

  Graph.prototype.toString = function() {
    return '[object Graph]';
  }

  Graph.prototype.getType = function() {
    return typeof this.type !== "undefined" ? this.type : "undefined";
  }

  Graph.prototype.update = function(options) {
    var that = this;

    this.action[this.type](options).then(function(newData) {
      that.data = newData;
    });
  }

  function formatGraphData(action, data) {
    var datetime, formattedData = [];
    _.each(data, function(d) {
      datetime = moment(d.date).utc();
      d.date   = datetime.format('YYYY-MM-DD');
      d.time   = datetime.format('HH:mm:ss');
      d.x      = datetime.date();
      if (action === 'monthly_revenue') d.y = d.revenue;
      else if (action === 'monthly_ad_cost') d.y = d.ad_cost;
      formattedData.push({
        'x': d.x,
        'y': d.y
      });
    });
    switch (action) {
      case "monthly_revenue":
        formattedData = [];
        _.map(_.groupBy(data, function(m) { return m.x; }),
          function(array) {
            formattedData.push({
              'x': _.first(array).x,
              'y': _.reduce(array, function(memo, obj) { return memo + obj.revenue; }, 0)
            });
          });
        return formattedData;
      case "monthly_ad_cost":
        return formattedData;
    }
  }

  var graphs = {};

  graphs.revenue = function(others) {
    var metric   = others.metric,
        title    = metric.getTitle(),
        subtitle = '£',
        type     = others.type;

    if (_.contains(['bar', 'bullet'], type)) {
      return new Graph({
        data: [],
        metric: metric,
        ylabel: title,
        subtitle: subtitle,
        type: type,
        action: {
          bar: function(options) {
            var deferred = $q.defer(),
                a        = "monthly_revenue";

            Opportunity.query({
              email: options.email,
              action: a,
              date_from: options.date_from,
              date_to: options.date_to
            }, function(data) {
              var formatted = formatGraphData(a, data)
              deferred.resolve(formatted);
            });

            return deferred.promise;
          },
          bullet: function(options) {
            var deferred = $q.defer(),
                previous = metric.getPreviousValue(),
                data = {};

            data.title    = title;
            data.subtitle = subtitle;
            data.previous = previous;
            data.value    = metric.getValue();
            data.ranges   = [previous*0.25, previous*0.5, previous*0.75];
            data.measures = [previous, metric.getValue()];
            data.markers  = [metric.getTarget()];

            deferred.resolve(data);

            return deferred.promise;
          }
        },
        options: {}
      });
    }
    else console.error("Invalid graph type.");
  }

  graphs.ad_cost = function(others) {
    var metric   = others.metric,
        title    = metric.getTitle(),
        subtitle = '£',
        type     = others.type;

    if (_.contains(['bar', 'bullet'], type)) {
      return new Graph({
        data: [],
        metric: metric,
        type: type,
        ylabel: title,
        subtitle: subtitle,
        action: {
          bar: function(options) {
            var deferred = $q.defer(),
                a        = "monthly_ad_cost";

            Adwordsdaily.query({
              acid: options.acid,
              action: a,
              date_from: options.date_from,
              date_to: options.date_to
            }, function(data) {
              var formatted = formatGraphData(a, data);
              deferred.resolve(formatted);
            });

            return deferred.promise;
          },
          bullet: function(options) {
            var deferred = $q.defer(),
                previous = metric.getPreviousValue(),
                data = {};

            data.title    = title;
            data.subtitle = subtitle;
            data.ranges   = [previous*0.25, previous*0.5, previous*0.75];
            data.measures = [previous, metric.getValue()];
            data.markers  = [metric.getTarget()];

            deferred.resolve(data);

            return deferred.promise;
          }
        },
        options: {}
      });
    }
    else console.error("Invalid graph type.");
  }

  graphs.profit = function(others) {
    var metric   = others.metric,
        title    = metric.getTitle(),
        subtitle = '£',
        type     = others.type;

    if (_.contains(['bar', 'bullet'], type)) {
      return new Graph({
        data: [],
        metric: metric,
        type: type,
        ylabel: title,
        subtitle: subtitle,
        action: {
          bullet: function(options) {
            var deferred = $q.defer(),
                previous = metric.getPreviousValue(),
                data = {};

            data.title    = title;
            data.subtitle = subtitle;
            data.ranges   = [previous*0.25, previous*0.5, previous*0.75];
            data.measures = [previous, metric.getValue()];
            data.markers  = [metric.getTarget()];

            deferred.resolve(data);

            return deferred.promise;
          }
        },
        options: {}
      });
    }
    else console.error("Invalid graph type.");
  }

  graphs.margin = function(others) {
    var metric   = others.metric,
        title    = metric.getTitle(),
        subtitle = '%',
        type     = others.type;

    if (_.contains(['bar', 'bullet'], type)) {
      return new Graph({
        data: [],
        metric: metric,
        type: type,
        ylabel: title,
        subtitle: subtitle,
        action: {
          bullet: function(options) {
            var deferred = $q.defer(),
                previous = metric.getPreviousValue(),
                data = {};

            data.title    = title;
            data.subtitle = subtitle;
            data.ranges   = [previous*0.25, previous*0.5, previous*0.75];
            data.measures = [previous, metric.getValue()];
            data.markers  = [metric.getTarget()];

            deferred.resolve(data);

            return deferred.promise;
          }
        },
        options: {}
      });
    }
    else console.error("Invalid graph type.");
  }

  return graphs;
});