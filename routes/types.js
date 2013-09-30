var Type = require('../models/type').Type;
var q    = require('q');

module.exports = {
  get: function(type) {
    return q.ninvoke(Type.find({
      type: type
    }, {
      key: true,
      value: true
    }), "exec");
  },
  all: function() {
    return q.ninvoke(Type.find(), "exec");
  }
};
