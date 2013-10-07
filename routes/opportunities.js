var db = require('../database');
var _  = require('lodash');

/* Validate each date in query parameters is in yyyy-mm-dd format */
var checkDates = function(dates) {
  var re = /(?:[1-2]\d{3}-[0-1]\d-[0-3]\d)/;
  _.each(dates, function(date) {
    if (typeof(date) === "undefined") return false;
    else if (date.match(re) === null) return false;
  });
  return true;
}

module.exports = {
  all: function(options) {
    return db.getConnection().then(function(connection) {
      var query;
      if (_.isEmpty(options)) query = "SELECT * FROM opportunities";
      else if (options.action === "total_revenue"
            && options.acid !== "undefined"
            && checkDates([options.date_from, options.date_to])) {
        query = [
          "SELECT SUM(revenue) AS total_revenue",
          "FROM opportunities",
          "WHERE acid=" + options.acid,
          "AND pipelinetext IN ('Won', '')",
          "AND date BETWEEN '" + options.date_from + "'",
          "AND '" + options.date_to + "';"
        ].join(' ');
      }
      else console.log("ERROR");
      console.log(query);
      return db.execQuery(connection, query);
    });
  },
  get: function(oid) {
    return db.getConnection().then(function(connection) {
      var query = "SELECT * FROM opportunities WHERE oid=" + oid;
      return db.execQuery(connection, query);
    });
  }
}