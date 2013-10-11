var db = require('../database');
var q  = require('q');

module.exports = {
  all: function() {
    return db.getConnection().then(function(connection) {
      var query = "SELECT * FROM accounts;";
      return db.execQuery(connection, query);
    });
  },
  getById: function(acid) {
    return db.getConnection().then(function(connection) {
      var query = "SELECT * FROM accounts WHERE acid='" + acid + "';";
      return db.execQuery(connection, query);
    });
  },
  getByEmail: function(email) {
    return db.getConnection().then(function(connection) {
      var query = "SELECT * FROM accounts WHERE email='" + email + "';";
      return db.execQuery(connection, query);
    });
  },
  getId: function(email) {
    return db.getConnection().then(function(connection) {
      var query = "SELECT acid FROM accounts WHERE email='" + email + "';";
      return db.execQuery(connection, query);
    });
  }
}