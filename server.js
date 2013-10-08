var app, connection, cons, dbErr, dbSuccess, express, fs, http, q, customers;

fs             = require('fs');
express        = require('express');
cons           = require('consolidate');
http           = require('http');
q              = require('q');
passport       = require('passport');
DigestStrategy = require('passport-http').DigestStrategy;
connection     = require('./connection');
customers      = require('./routes/customers');
opportunities  = require('./routes/opportunities');
app            = express();

app.configure(function() {
  app.set('port', 8080);
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(passport.initialize());
  app.use(passport.session());
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

passport.use(new DigestStrategy({ qop: 'auth' },
  function(username, done) {
    // Find the user by username.  If there is no user with the given username
    // set the user to `false` to indicate failure.  Otherwise, return the
    // user and user's password.
    findByUsername(username, function(err, user) {
      if (err) { return done(err); }
      if (!user) { return done(null, false); }
      return done(null, user, user.password);
    })
  },
  function(params, done) {
    // asynchronous validation, for effect...
    process.nextTick(function() {
      // check nonces in params here, if desired
      return done(null, true);
    });
  }
));

// select * from opportunities WHERE date LIKE '%2013-09-30%';

var dbSuccess = function(res, prop, log) {
  if (log == null) log = false;
  return function(data) {
    if (log) console.log(log);
    if (data.length === 1) prop = 0;
    return res.json(prop != null ? data[prop] : data);
  };
};

var dbErr = function(res) {
  return function(err) {
    console.log(err);
    if (err.code != null) {
      return res.send(err.code, err.message);
    }
    else return res.send(500, err);
  };
};

/* Login */

app.post('/login', passport.authenticate('digest', { session: false }),
  function(req, res) {
    // res.json({ username: req.user.username, email: req.user.email });
    res.redirect('/dashboard/' + req.user.acid);
  });

/* Customers */
app.get('/api/v1/customers', function(req, res) {
  customers.all().then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/customers/:acid', function(req, res) {
  customers.get(req.params.acid).then(dbSuccess(res), dbErr(res));
});

/* Opportunities */
app.get('/api/v1/opportunities', function(req, res) {
  opportunities.all(req.query).then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/opportunities/:oid', function(req, res) {
  opportunities.get(req.params.oid).then(dbSuccess(res), dbErr(res));
});

app.get('*', function(req, res, next) {
  if (req.query._escaped_fragment_ != null) return next();
  else return res.sendfile('_public/index.html');
});

http.createServer(app).listen(app.get('port'), function() {
  return console.log('Express server listening on port ' + app.get('port'));
});
