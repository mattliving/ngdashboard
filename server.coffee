fs        = require 'fs'
express   = require 'express'
cons = require 'consolidate'
http      = require 'http'
mongoose  = require 'mongoose'
path      = require 'path'
routes    = require './routes'
resources = require './routes/resources'
{Content} = require './models/content'
{Task}    = require './models/task'

# Create server
app = express()

app.configure ->
  app.set 'port', 8080
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.enable 'trust proxy'
  # these let us use express's built in rendering with _.template
  app.engine 'html', cons.underscore
  app.set 'view engine', 'html'
  app.set 'views', __dirname + '/static-pages'
  # workaround for express overriding the / route and returning index.html to google
  app.use (req, res, next) ->
    if req.query._escaped_fragment_? and req.path is '/'
      Content.findOne(key: "options").exec (err, options) ->
        unless err
          res.render 'landing', options: options.data
        else
          res.render '404'
    else
      next()
  app.use express.static(__dirname + '/app')

mongoose.connect('mongodb://localhost/jobfoundry')

### API ###

# Resources
app.get '/api/v1/resources', (req, res) ->
  resources.all().then (resources) -> res.json resources
app.get '/api/v1/resources/:id', (req, res) ->
  resources.get(req.params.id).then (resource) -> res.json resource
app.post '/api/v1/resources', (req, res) ->
  resources.add(req.body).then (success) -> res.json success
app.delete '/api/v1/resources/:id', (req, res) ->
  resources.delete(req.params.id).then (success) -> res.json success
app.put '/api/v1/resources/:id', (req, res) ->
  resources.edit(req.params.id, req.body).then (success) -> res.json success

# Content
app.get '/api/v1/content/:key', routes.content.get

# Tasks
app.get '/api/v1/tasks/:name', routes.tasks.get

# Pages

# Check for other routes if google's making the request, otherwise send index.html
app.get '*', (req, res, next) ->
  console.log req.path
  if req.query._escaped_fragment_?
    next()
  else
    res.sendfile 'app/index.html'

app.get '/task/:name', (req, res) ->
  Task.findOne(name: req.params.name).populate('resources').exec (err, task) ->
    res.render 'task', task: task

# this currently doesn't get called because the static fileserver has precedence
app.get '/', (req, res) ->
  Content.findOne(key: "options").exec (err, options) ->
    unless err
      res.render 'landing', options: options.data


# not currently used

# Site
# app.get '/paths', routes.site.paths
# app.get '/:path/topics', routes.site.topics
# app.get '/:path/topicsByName', routes.site.topicsByName
# app.get '/:path/topicDependancies', routes.site.topicDependancies

# app.get '/resources/:path', routes.resources.path
# app.get '/resources/:path/:topic', routes.resources.topic
# app.get '/:path/:topic?level=:level', routes.resources.level
# app.get '/:path/:topic?type=:type', routes.resources.type
# app.get '/:path/:topic?type=:type&level=:level', routes.resources.typeAndLevel

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'
