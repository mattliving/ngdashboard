var mysql = require('mysql');

module.exports = {
  connection: mysql.createConnection({
    user: 'root',
    database: 'dashboard'
  }).connect()
}