express  = require 'express'
http     = require 'http'
mongoose = require 'mongoose'
path     = require 'path'
routes   = require './routes'

# Create server
app = express()

app.configure ->
  app.set 'port', 7000
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.enable 'trust proxy'
  app.use (req, res, next) ->
    if req.query._escaped_fragment_?
      res.send "Google is watching!"
    else
      next()
  app.use express.static(__dirname + '/app')

mongoose.connect('mongodb://localhost/jobfoundry')

# Resources
app.get '/resources', routes.resources.all
app.post '/resources', routes.resources.add
app.delete '/resources/:id', routes.resources.delete

# not currently used

# Site
app.get '/paths', routes.site.paths
app.get '/:path/topics', routes.site.topics
app.get '/:path/topicsByName', routes.site.topicsByName
app.get '/:path/topicDependancies', routes.site.topicDependancies

app.get '/resources/:path', routes.resources.path
app.get '/resources/:path/:topic', routes.resources.topic
# app.get '/:path/:topic?level=:level', routes.resources.level
# app.get '/:path/:topic?type=:type', routes.resources.type
# app.get '/:path/:topic?type=:type&level=:level', routes.resources.typeAndLevel

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'
