fs = require 'fs'
webshot = require 'webshot'
mongoose  = require 'mongoose'
{Resource} = require './models/resource'
{spawn} = require 'child_process'

mongoose.connect('mongodb://localhost/jobfoundry')

Resource.find().select('link').exec (err, resources) ->

  index = 0
  cwd = require('path').dirname(require.main.filename)

  do next = ->
    if index < resources.length
      resource = resources[index++]

      path = "/app/assets/images/screenshots/#{resource._id}.png"
      fs.exists cwd + path, (exists) ->
        unless exists
          console.log "rendering #{resource.link} to #{resource._id}.png (#{index} of #{resources.length})"
          render = spawn 'coffee', ['render.coffee', resource.link, resource._id], cwd: cwd
          render.on 'exit', next
        else
          console.log "already rendered #{resource.link}"
          next()
    else
      mongoose.disconnect()
      console.log 'done rendering'
