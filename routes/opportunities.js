var db      = require('../database');
var helpers = require('../helpers');
var _       = require('lodash');
var q       = require('q');

module.exports = {
  all: function(params) {
    return db.getConnection().then(function(connection) {
      var query;
      if (_.isEmpty(params)) query = "SELECT * FROM opportunities";
      else if (typeof params.email !== "undefined"
            && helpers.checkDates([params.date_from, params.date_to])) {
        if (params.action === "total_revenue") {
          query = [
            "SELECT ROUND(SUM(revenue), 2) AS total_revenue",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND pipelinetext IN ('Won', '')",
            "AND date BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "';"
          ].join(' ');
        }
        else if (params.action === "monthly_revenue") {
          query = [
            "SELECT date, revenue",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND pipelinetext IN ('Won', '')",
            "AND date BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "';"
          ].join(' ');
        }
        else if (params.action === 'weighted_average_margin') {
          query = [
            "SELECT (SUM(revenue*margin_percent/100) / SUM(revenue)) * 100 AS weighted_average_margin",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND margin_percent IS NOT NULL",
            "AND margin_percent != 0",
            "AND date BETWEEN '" + params.date_from + "'",
            "AND '" + params.date_to + "';"
          ].join(' ');
        }
        else if (params.action === 'margin_integrity') {
          query = [
            "SELECT (margin_count/total_count)*100 AS margin_integrity",
            "FROM (SELECT COUNT(margin_percent) AS margin_count",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND date BETWEEN '" + params.date_from + "' AND '" + params.date_to + "'",
            "AND margin_percent != 0) AS t1,",
            "(SELECT COUNT(margin_percent) AS total_count",
            "FROM opportunities",
            "WHERE acid=(SELECT acid FROM accounts WHERE email='" + params.email + "')",
            "AND date BETWEEN '" + params.date_from + "' AND '" + params.date_to + "') AS t2;"
          ].join(' ');
        }
        else if (params.action === 'clv') {
          //select sum(revenue) as CLV, tid from opportunities where pipeline=13 group by tid order by CLV
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