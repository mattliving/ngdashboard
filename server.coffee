fs        = require 'fs'
express   = require 'express'
cons      = require 'consolidate'
http      = require 'http'
mongoose  = require 'mongoose'
path      = require 'path'
resources = require './routes/resources'
projects  = require './routes/projects'
tasks     = require './routes/tasks'
content   = require './routes/content'

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
      content.get("options").then (options) ->
        res.render 'landing', options: options.data
    else
      next()
  app.use express.compress()
  app.use express.static(__dirname + '/_public')

mongoose.connect('mongodb://localhost/jobfoundry')

### API ###
# Add error handling to this, or to express

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
app.get '/api/v1/content/:key', (req, res) ->
  content.get(req.params.key).then (data) -> res.json data["data"]

# Projects
app.get '/api/v1/projects', (req, res) ->
  projects.all().then (projects) -> res.json projects
app.get '/api/v1/projects/:name', (req, res) ->
  projects.get(req.params.name).then (project) -> res.json project

# Tasks
app.get '/api/v1/tasks', (req, res) ->
  tasks.all().then (tasks) -> res.json tasks
app.get '/api/v1/tasks/:name', (req, res) ->
  tasks.get(req.params.name).then (task) -> res.json task

# Pages

# Check for other routes if google's making the request, otherwise send index.html
app.get '*', (req, res, next) ->
  if req.query._escaped_fragment_?
    next()
  else
    res.sendfile '_public/index.html'

app.get '/task/:name', (req, res) ->
  tasks.get(req.params.name).then (task) ->
    res.render 'task', task: task

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'
