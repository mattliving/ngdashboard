var _ = require('lodash');

module.exports = {

  /* Validate each date in query parameters is in yyyy-mm-dd format */
  checkDates: function(dates) {
    var re = /(?:[1-2]\d{3}-[0-1]\d-[0-3]\d)/;
    return _.every(dates, function(date) {
      if (typeof date === "undefined") return false
      else if (date.match(re) === null) return false;
      else return true;
    });
  }
}