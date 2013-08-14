express  = require 'express'
http     = require 'http'
mongoose = require 'mongoose'
path     = require 'path'
routes   = require './routes'

# Create server
app = express()

app.configure ->
  app.set 'port', 8080
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.enable 'trust proxy'
  app.use (req, res, next) ->
    req.google = req.query._escaped_fragment_?
    next()
  app.use express.static(__dirname + '/app')

mongoose.connect('mongodb://localhost/jobfoundry')

# API
app.get '/api/v1/resources', routes.resources.all
app.get '/api/v1/resources/:id', routes.resources.get
app.post '/api/v1/resources', routes.resources.add
app.delete '/api/v1/resources/:id', routes.resources.delete
app.put '/api/v1/resources/:id', routes.resources.edit

# Pages
app.get '*', (req, res) ->
  if req.google
    # return rendered html
    res.send 'hey google'
  else
    res.sendfile 'app/index.html'
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
