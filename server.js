var app, adwords, cons, crypto, dbErr, dbSuccess, LocalStrategy, express, fs, http, passport, q, customers, opportunities;

cons          = require('consolidate');
crypto        = require('crypto');
express       = require('express');
fs            = require('fs');
http          = require('http');
q             = require('q');
passport      = require('passport');
LocalStrategy = require('passport-local').Strategy;
adwords       = require('./routes/adwords');
customers     = require('./routes/customers');
opportunities = require('./routes/opportunities');
app           = express();

var md5sum = crypto.createHash('md5');

function verifyPassword(user, password) {
  md5sum.update(password);
  var d = md5sum.digest('hex');
  return (d === user.password) ? true : false;
}

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login');
}

passport.serializeUser(function(user, done) {
  console.log("serializing...");
  console.log(user);
  done(null, user.acid);
});

passport.deserializeUser(function(id, done) {
  customers.getById(id).then(function(user) {
    console.log("deserializing...");
    console.log(user);
    done(null, user);
  }, function(err) { done(err, false); });
});

passport.use(new LocalStrategy({
    usernameField: 'email'
  },
  function(email, password, done) {
    process.nextTick(function() {
      // Find the user by email.  If there is no user with the given username
      // set the user to `false` to indicate failure.  Otherwise, return the
      // user and user's password.
      customers.getByEmail(email).then(function(user) {
        console.log(user);
        if (user.length === 1) user = user[0];
        if (!user) { return done(null, false, { message: 'Incorrect username.' }); }
        if (!verifyPassword(user, password)) { return done(null, false, { message: 'Incorrect password.' }); }
        console.log("user and password verified");
        return done(null, user);
      }), function(err) {
        console.log(err);
        return done(err, false, { message: 'Database error.'});
      }
    });
  }
));

app.configure(function() {
  app.set('port', 8080);
  app.set('views', __dirname + '/static-pages');
  app.set('view engine', 'html');
  app.enable('trust proxy');
  app.engine('html', cons.underscore);
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(passport.initialize());
  app.use(passport.session());
  return app.use(express["static"](__dirname + '/_public'));
});

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

app.post('/login', passport.authenticate('local', { failureRedirect: '/login' }),
  function(req, res) {
    res.redirect(req.user.email + '/dashboard');
  }
);

/* Customers */

app.get('/api/v1/customers', function(req, res) {
  customers.all().then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/customers/:email', function(req, res) {
  customers.getByEmail(req.params.email).then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/customers/:email/id', function(req, res) {
  customers.getId(req.params.email).then(dbSuccess(res), dbErr(res));
});

/* Opportunities */

app.get('/api/v1/opportunities', function(req, res) {
  opportunities.all(req.query).then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/opportunities/:oid', function(req, res) {
  opportunities.get(req.params.oid).then(dbSuccess(res), dbErr(res));
});

/* Adwords */

app.get('/api/v1/adwordsdaily', function(req, res) {
  adwords.all().then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/adwordsdaily/:acid', function(req, res) {
  adwords.get(req.params.acid, req.query).then(dbSuccess(res), dbErr(res));
});

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

app.get('*', function(req, res, next) {
  if (req.query._escaped_fragment_ != null) return next();
  else return res.sendfile('_public/index.html');
});

http.createServer(app).listen(app.get('port'), function() {
  return console.log('Express server listening on port ' + app.get('port'));
});
