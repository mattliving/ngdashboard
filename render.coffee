fs = require 'fs'
gm = require 'gm'
webshot = require 'webshot'
[node, script, url, filename] = process.argv

console.log 'dir', __dirname

directory = __dirname + "/app/assets/images/screenshots/"
filename += '.png'

console.log directory + filename

webshot url, (err, stream) ->
  gm(stream, filename).resize(200).write directory + filename, (err) ->
    if err
      console.log 'err:', err
    else
      console.log 'success'
