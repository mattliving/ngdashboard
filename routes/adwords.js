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
      if (acid !== "undefined") {
        if (_.isEmpty(params)) query = "SELECT * FROM adwordsdaily WHERE acid='" + acid + "'";
        else if (helpers.checkDates([params.date])) {
          query = [
            "SELECT SUM(adclicks*adcost) as total_ad_cost",
            "FROM adwordsdaily",
            "WHERE acid='" + acid + "'",
            "AND day='" + params.date + "'",
            "GROUP BY day;"
          ].join(' ');
        }
      }
      else console.log("ERROR"); /* TODO ERROR HANDLING */
      console.log(query);
      return db.execQuery(connection, query);
    });
  }
}