var db      = require('../database');
var helpers = require('../helpers');
var _       = require('lodash');
var q       = require('q');

module.exports = {
  all: function(params) {
    return db.getConnection().then(function(connection) {
      var query;
      if (_.isEmpty(params)) query = "SELECT * FROM opportunities";
      else if (params.email !== "undefined"
            && helpers.checkDates([params.date_from, params.date_to])) {
        if (params.action === "total_revenue") {
          query = [
            "SELECT SUM(revenue) AS total_revenue",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND pipelinetext IN ('Won', '')",
            "AND date BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "';"
          ].join(' ');
        }
        else if (params.action === "revenue_over_time") {
          query = [
            "SELECT date, revenue",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND pipelinetext IN ('Won', '')",
            "AND date BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "';"
          ].join(' ');
        }
      }
      else console.log("ERROR"); /* TODO ERROR HANDLING */
      return db.execQuery(connection, query);
    });
  },
  get: function(oid) {
    return db.getConnection().then(function(connection) {
      var query = "SELECT * FROM opportunities WHERE oid='" + oid + "';";
      return db.execQuery(connection, query);
    });
  }
}