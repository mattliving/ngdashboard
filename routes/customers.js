var db = require('../database');
var q  = require('q');

module.exports = {
  all: function() {
    return db.getConnection().then(function(connection) {
      var query    = "SELECT email, password FROM accounts";
      var deferred = q.defer();
      connection.query(query, function(err, results) {
        if (err) throw err;
        deferred.resolve(results);
      });
      return deferred.promise;
    });
  }
}