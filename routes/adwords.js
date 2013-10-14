var db      = require('../database');
var helpers = require('../helpers');
var q       = require('q');
var _       = require('lodash');

module.exports = {
  all: function(params) {
    return db.getConnection().then(function(connection) {
      var query;
      if (_.isEmpty(params)) query = "SELECT * FROM adwordsdaily";
      return db.execQuery(connection, query);
    });
  },
  get: function(acid, params) {
    return db.getConnection().then(function(connection) {
      var query;
      if (_.isEmpty(params)) query = "SELECT * FROM adwordsdaily WHERE acid='" + acid + "'";
      else if (typeof acid !== "undefined"
              && helpers.checkDates([params.date_from, params.date_to])) {
        if (params.action === "total_ad_cost") {
          query = [
            "SELECT ROUND(SUM(adcost), 2) AS total_ad_cost",
            "FROM adwordsdaily",
            "WHERE acid='" + acid + "'",
            "AND day BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "';"
          ].join(' ');
        }
        else if (params.action === "monthly_ad_cost") {
          query = [
            "SELECT day AS date, SUM(ad_cost) AS ad_cost",
            "FROM (SELECT day, (adcost) AS ad_cost",
            "FROM adwordsdaily",
            "WHERE acid='" + acid + "'",
            "AND day BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "')",
            "AS days",
            "GROUP BY day;"
          ].join(' ');
        }
      }
      else console.log("ERROR"); /* TODO ERROR HANDLING */
      return db.execQuery(connection, query);
    });
  }
}

// else if (helpers.checkDates([params.date])) {
//   query = [
//     "SELECT SUM(adclicks*adcost) as total_ad_cost",
//     "FROM adwordsdaily",
//     "WHERE acid='" + acid + "'",
//     "AND day='" + params.date + "'",
//     "GROUP BY day;"
//   ].join(' ');
// }