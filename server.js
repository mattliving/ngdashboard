var _, app, adwords, cons, crypto, uuid, LocalStrategy, express, fs, http, passport, q, customers, opportunities;

_             = require('lodash')
cons          = require('consolidate');
crypto        = require('crypto');
express       = require('express');
fs            = require('fs');
http          = require('http');
q             = require('q');
uuid          = require('node-uuid');
passport      = require('passport');
LocalStrategy = require('passport-local').Strategy;
adwords       = require('./routes/adwords');
customers     = require('./routes/customers');
opportunities = require('./routes/opportunities');
app           = express();

function verifyPassword(user, password) {
  var md5sum = crypto.createHash('md5');
  md5sum.update(password);
  var d = md5sum.digest('hex');
  return (d === user.password) ? true : false;
}

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  if (req.path.match("/api")) {
    res.send(401, {error: "Invalid API Key."});
  }
  else res.redirect('/login');
}

function checkLoginStatus(req, res, next) {
  if (req.isAuthenticated()) {
    req.session.destroy();
  }
  return next();
}

passport.serializeUser(function(user, done) {
  console.log("serializing...");
  done(null, {acid: user.acid, email: user.email});
});

passport.deserializeUser(function(serialized, done) {
  customers.getById(serialized.acid).then(function(user) {
    console.log("deserializing...");
    done(null, user);
  }, function(err) {
    console.err("error deserializing.");
    done(err, false);
  });
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

        if (user.length === 1) user = user[0];

        if (_.isEmpty(user)) {
          console.error("Incorrect username.");
          return done(null, false, { message: 'Incorrect username.' });
        }
        else if (!verifyPassword(user, password)) {
          console.error("Incorrect password.");
          return done(null, false, { message: 'Incorrect password.' });
        }
        console.log("User and password verified.");

        var returnUser = {
          acid: user.acid,
          email: user.email
        }
        return done(null, returnUser);
      }), function(err) {
        console.error("User login error.", err);
        return done(err, false, { message: 'Database error.'});
      }
    });
  }
));

app.configure(function() {
  app.set('port', 8081);
  app.set('views', __dirname + '/static-pages');
  app.set('view engine', 'html');
  app.enable('trust proxy');
  app.engine('html', cons.underscore);
  app.use(express["static"](__dirname + '/_public'));
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.session({secret: 'lucky888'}));
  app.use(express.methodOverride());
  app.use(passport.initialize());
  app.use(passport.session());
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

app.post('/login', checkLoginStatus, passport.authenticate('local', {
  failureRedirect: '/login'
}), function(req, res) {
  // req.session.previous = '/login';
  console.log('redirect to ' + req.user.email + '/dashboard');
  res.redirect(req.user.email + '/dashboard');
});

app.get('/logout', function(req, res) {
  req.logout();
  res.redirect('/');
});

app.get('/:email/dashboard/verify', function(req, res) {
  if (_.isUndefined(req.session.passport.user)) {
    res.send(401);
  }
  else if (req.session.passport.user.email !== req.params.email) {
    res.send(401);
  }
  else {
    res.send(200);
  }
});

/* Customers */

app.get('/api/v1/customers', ensureAuthenticated, function(req, res) {
  customers.all().then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/customers/:email', ensureAuthenticated, function(req, res) {
  customers.getByEmail(req.params.email).then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/customers/:email/id', ensureAuthenticated, function(req, res) {
  customers.getId(req.params.email).then(dbSuccess(res), dbErr(res));
});

/* Opportunities */

app.get('/api/v1/opportunities', ensureAuthenticated, function(req, res) {
  opportunities.all(req.query).then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/opportunities/:oid', ensureAuthenticated, function(req, res) {
  opportunities.get(req.params.oid).then(dbSuccess(res), dbErr(res));
});

/* Adwords */

app.get('/api/v1/adwordsdaily', ensureAuthenticated, function(req, res) {
  adwords.all().then(dbSuccess(res), dbErr(res));
});

app.get('/api/v1/adwordsdaily/:acid', ensureAuthenticated, function(req, res) {
  adwords.get(req.params.acid, req.query).then(dbSuccess(res), dbErr(res));
});

app.get('*', function(req, res, next) {
  if (req.query._escaped_fragment_ != null) return next();
  else return res.sendfile('_public/index.html');
});

http.createServer(app).listen(app.get('port'), function() {
  return console.log('Express server listening on port ' + app.get('port'));
});
