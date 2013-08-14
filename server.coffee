fs        = require 'fs'
express   = require 'express'
cons = require 'consolidate'
http      = require 'http'
mongoose  = require 'mongoose'
path      = require 'path'
_         = require 'lodash'
routes    = require './routes'
{Content} = require './models/content'

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

  # function to handle sending stuff to google
  app.use (req, res, next) ->
    if req.query._escaped_fragment_?
      switch req.path
        when '/'
          Content.findOne(key: "options").exec (err, options) ->
            unless err
              res.render 'landing', options: options.data
            else
              res.status(500).render '404'
        else
          res.status(404).render '404'
    else
      next()
  app.use express.static(__dirname + '/app')

mongoose.connect('mongodb://localhost/jobfoundry')

### API ###

# Resources
app.get '/api/v1/resources', routes.resources.all
app.get '/api/v1/resources/:id', routes.resources.get
app.post '/api/v1/resources', routes.resources.add
app.delete '/api/v1/resources/:id', routes.resources.delete
app.put '/api/v1/resources/:id', routes.resources.edit

# Content
app.get '/api/v1/content/:key', routes.content.get

# Pages
# this definitely needs to be a little more robust...
app.get '*', (req, res) -> res.sendfile 'app/index.html'

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
