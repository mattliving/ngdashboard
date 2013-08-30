fs = require 'fs'
gm = require 'gm'
webshot = require 'webshot'
[node, script, url, filename] = process.argv

console.log 'dir', __dirname

directory = __dirname + "/app/assets/images/screenshots/"
extension = '.png'

console.log directory + filename + extension

webshot url, (err, stream) ->
  gm(stream, filename + extension).write directory + filename + extension, (err) ->
    if err
      console.log 'err:', err
    else
      console.log 'success'
