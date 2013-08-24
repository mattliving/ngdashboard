fs = require 'fs'
webshot = require 'webshot'
resources = require './resources.json'

index = -1

do render = (err = false) ->
  if err then console.log 'err ', err
  index++
  if index < resources.length
    resource = resources[index]
    filename = "app/assets/images/screenshots/#{resource._id}.png"
    fs.exists filename, (exists) ->
      if not exists
        console.log 'rendering ' + resource.link
        webshot resource.link, filename, render
      else
        console.log 'already rendered ' + resource.link
        render()
