var app, cons, dbErr, dbSuccess, express, fs, http;

fs      = require('fs');
express = require('express');
cons    = require('consolidate');
http    = require('http');
app     = express();

app.configure(function() {
  app.set('port', 8080);
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.enable('trust proxy');
  app.engine('html', cons.underscore);
  app.set('view engine', 'html');
  app.set('views', __dirname + '/static-pages');
  app.use(function(req, res, next) {
    if ((req.query._escaped_fragment_ != null) && req.path === '/') {
      return content.get("options").then(function(options) {
        return res.render('landing', {
          options: options.data
        });
      });
    } else {
      return next();
    }
  });
  app.use(express.compress());
  return app.use(express["static"](__dirname + '/_public'));
});

dbSuccess = function(res, prop, log) {
  if (log == null) {
    log = false;
  }
  return function(data) {
    if (log) {
      console.log(log);
    }
    return res.json(prop != null ? data[prop] : data);
  };
};

dbErr = function(res) {
  return function(err) {
    if (err.code != null) return res.send(err.code, err.message);
    else return res.send(500, err);
  };
};

app.get('*', function(req, res, next) {
  if (req.query._escaped_fragment_ != null) return next();
  else return res.sendfile('_public/index.html');
});

http.createServer(app).listen(app.get('port'), function() {
  return console.log('Express server listening on port ' + app.get('port'));
});
