var mysql = require('mysql');
var q     = require('q');

var pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  database: 'luckydb',
  connectionlimit: 10,
  supportBigNumbers: true
});

module.exports = {

  getConnection: function() {
    var deferred = q.defer();
    pool.getConnection(function(err, connection) {
      if (err) {
        console.log(err);
        callback(true);
        return;
      }
      deferred.resolve(connection);
    });
    return deferred.promise;
  }
}